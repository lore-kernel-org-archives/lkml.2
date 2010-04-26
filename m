Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0DZKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:09:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34791 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0DZKJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jtfCQrLSQh7cFppvyWOv5nJ5larcAWby+da1FSHm+XUsv7Nwk4u9+NG251FXmy4UvT
         N/gKMLAFwUREMT5bYzvNaHk3Y6sI/83KCFT9MnNWJ0zFEm6B/wUiuFsRg3rmkRhZub+L
         RDFc6vpBYcF5ohwZp0bPrXk31RfL49FgCKgzg=
MIME-Version: 1.0
In-Reply-To: <4BD564BE.6020700@kernel.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>
	 <alpine.DEB.2.00.1004221045270.1204@router.home>
	 <4BD086D0.9090309@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>
	 <1272265147.2078.648.camel@ymzhang.sh.intel.com>
	 <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>
	 <4BD564BE.6020700@kernel.org>
Date: Mon, 26 Apr 2010 13:09:21 +0300
X-Google-Sender-Auth: 7a5496ea4df98d7c
Message-ID: <x2o84144f021004260309k9edf9e88t92e4c988d12de234@mail.gmail.com>
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tejun Heo <tj@kernel.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tim.c.chen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 26, 2010 at 9:59 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
>>>> I haven't been able to reproduce this either on my Core 2 machine.
>>> Mostly, the regression exists on Nehalem machines. I suspect it's related to
>>> hyper-threading machine.

On 04/26/2010 09:22 AM, Pekka Enberg wrote:
>> OK, so does anyone know why hyper-threading would change things for
>> the per-CPU allocator?

On Mon, Apr 26, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> My wild speculation is that previously the cpu_slub structures of two
> neighboring threads ended up on the same cacheline by accident thanks
> to the back to back allocation.  W/ the percpu allocator, this no
> longer would happen as the allocator groups percpu data together
> per-cpu.

Yanmin, do we see a lot of remote frees for your hackbench run? IIRC,
it's the "deactivate_remote_frees" stat when CONFIG_SLAB_STATS is
enabled.

                        Pekka
