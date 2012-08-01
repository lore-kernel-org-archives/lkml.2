Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2HAGuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 02:50:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:48277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2HAGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 02:50:18 -0400
Date: Wed, 1 Aug 2012 08:50:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: CAI Qian <caiqian@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, Zhouping Liu <zliu@redhat.com>
Subject: Re: boot panic regression introduced in 3.5-rc7
In-Reply-To: <501771CA.1090304@us.ibm.com>
Message-ID: <alpine.LFD.2.02.1208010847590.32033@ionos>
References: <1971950954.1278169.1343620316300.JavaMail.root@redhat.com> <501771CA.1090304@us.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012, John Stultz wrote:
> On 07/29/2012 08:51 PM, CAI Qian wrote:
> Now, one of the reasons Thomas and I changed the logic was that using the
> precalculated realtime_offset was slightly more efficient then re-adding xtime
> and wall_to_monotonic's components separately. But how valuable this
> unmeasured slight efficiency is vs extra robustness for crazy time values is
> questionable.

Well, I guess it unearthed a weakness which has been there forever:

  Trusting random values which are supplied by cmos or whatever.

So the right fix is:
 
> 2) Validate that time values we accept are smaller the ktime_t before using
> them.

I really don't like the magic workaround by nulling out the effect of
crap data with a more expensive calculation.

Thanks,

	tglx
