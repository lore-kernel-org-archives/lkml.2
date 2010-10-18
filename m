Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0JRPYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:24:16 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43794 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755333Ab0JRPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:24:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: HCgpbWkVM1l8vk1mIU2dmMR5Vt7bqCcgmWn9uciaXFZ91R0
 7n_2n16KTD2xVbIEXE7xXGPTd13hHrWp1WlQYZC0u2HxE_J.zI8buDw1SYiI
 7cbiwnDVDfixdVbUBpuEETpMBmArwcxr3j3.mC1.RThDIJhJ_8Ltcw7MaKEX
 Gctsa3Bd9z.1a5m7gEKAO08A6nt.ivR_4VLeFsY.oCDg_k8vrY_6020p7AMM
 w
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 18 Oct 2010 10:24:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
In-Reply-To: <1287238754.2799.376.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010181015290.755@router.home>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>  <1285762729-17928-17-git-send-email-david@fromorbit.com>  <20100929215322.ff635d3e.akpm@linux-foundation.org>  <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd> 
 <1287217748.2799.68.camel@edumazet-laptop>  <20101016020744.366bd9c6.akpm@linux-foundation.org>  <1287221475.2799.123.camel@edumazet-laptop> <1287238754.2799.376.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Eric Dumazet wrote:

> I based following patch against linux-2.6, I dont know if previous
> Christoph patch is in a git tree. I'll respin it eventually.

The prior patch was accepted by Andrew.

> + * - It is preempt safe, but not IRQ safe (on UP)

The IRQ safeness depends on the arch. this_cpu_add() in general only
guarantees safety against preemption. It so happens that the x86
implementation is irq safe as well.

The IRQ safety for UP is therefore not an issue if you use this_cpu_add().

If you want to guarantee irqsafeness then use irqsafe_cpu_add() instead.
It generates the same code on x86 for SMP but takes care of the UP issues.

> +static inline void percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
> +{
> +	this_cpu_add(*fbc->counters, amount);
> +}

What happens in case of counter overflow?

