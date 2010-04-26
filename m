Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0DZHWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 03:22:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:53742 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0DZHWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 03:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Ti7fSJ3SiuJRFDn1ISJP8LYMx+OJJ7YxjS+CjecLwx8OJo0YgKN0hwzo0C9IbjfoiN
         D89q32qONX8bO00cynbKqLcgj1iM1LsXOPEyNAT3gYflpPUiXEahgBQ5AV5i3bILlVMP
         fPmb49vp+jAAZjcB7qef8Jprh1doomkwVfwgA=
MIME-Version: 1.0
In-Reply-To: <1272265147.2078.648.camel@ymzhang.sh.intel.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>
	 <alpine.DEB.2.00.1004221045270.1204@router.home>
	 <4BD086D0.9090309@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>
	 <1272265147.2078.648.camel@ymzhang.sh.intel.com>
Date: Mon, 26 Apr 2010 10:22:05 +0300
X-Google-Sender-Auth: 67e1f5b8c6359fa0
Message-ID: <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tj@kernel.org, tim.c.chen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,

On Mon, Apr 26, 2010 at 9:59 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
>> I haven't been able to reproduce this either on my Core 2 machine.
> Mostly, the regression exists on Nehalem machines. I suspect it's related to
> hyper-threading machine.

OK, so does anyone know why hyper-threading would change things for
the per-CPU allocator?

>> Yanmin, does something like this help on your machines?
> A quick testing doesn't show any help.

So it's unlikely to be false sharing, I suppose.

> I did a new testing. After the machine boots, I hot remove 8 hyper-threading cpu
> which means last 8 are just cores. The regression between 2.6.33 and 2.6.34-rc becomes
> small.
>
> My opinion is we needn't revert the patch, but still keep an eye on it when testing other
> new RC kernel releases. One reason is volanoMark and netperf have no such regression.
> Is it ok?

We need to get this fixed. In my experience, it's pretty common that
slab regressions pop up only in one or few benchmarks. The problem is
likely to pop up in some real-world workload where it's even more
difficult to track down because basic CPU profiles don't pin-point the
problem.

Do we have some Intel CPU expert hanging around here that could
enlighten me of the effects of hyper-threading on CPU caching? I also
wonder why it's showing up with the new per-CPU allocator and not with
the homebrewn one we had in SLUB previously.

                        Pekka
