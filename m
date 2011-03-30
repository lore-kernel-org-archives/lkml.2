Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1C3QPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:15:45 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:48992 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756065Ab1C3QPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:15:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: yfS5_GYVM1ngzSUEqo71NJ66vAUSPXNecs__X28w2wKPd6d
 tynTqwtC6LAtZix2Io7gPXWwm8rCtX8kLZ4R5PSq1QHVyW8Uye3hUemLV5NY
 FknfOcy4kF3Uxo3o369J8XcdmHVM7aoyuifesQlvqPnj_XhfWA97aZcsguiL
 2OKH9f8RPFr0UB6ic93Lpw6fV9WnL2oeFQLHNKnwX9wy.8_lWSU9J5HCMKFR
 IePLuPEFBY5yLF1ijCTFQgMC9NuD.a.INvJwHSoDb0jvTuJIyh4HFiWubEV9
 _SGMekiSyBbJqmMm77pS49qNlIlk0M8usqJj0lFwW5NhFgl0D
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 30 Mar 2011 11:15:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities of
 the current cpu
In-Reply-To: <20110330160756.GL17523@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103301113510.27742@router.home>
References: <20110312115010.GC2005@htj.dyndns.org> <m2k4g1zdmt.fsf@firstfloor.org> <4D93531F.5080403@zytor.com> <20110330160756.GL17523@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Tejun Heo wrote:

> Hello,
>
> On Wed, Mar 30, 2011 at 08:58:23AM -0700, H. Peter Anvin wrote:
> > >> Add this_cpu_has() which determines if the current cpu has a certain
> > >> ability using a segment prefix and a bit test operation.
> > >
> > >
> > > Hmm: if the CPU capability is really tested in a performance critical
> > > path, wouldn't it even be better to just use static_branch() now?
> > >
> >
> > We have static_cpu_has() for this specific purpose (it actually predates
> > static_branch()).
>
> These patches have performance benefits but I don't think it would be
> noticeable.  I think it's more of code cleanup.

The main simplification is that the pointer to the cpu_info can be
omitted. Its passed around quite a bit right now in x86 arch code.
Removal of the cpu_info pointer could reduce code size and allow faster
access.


