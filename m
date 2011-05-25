Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1EYP2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:28:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60276 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1EYP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:28:21 -0400
Date: Wed, 25 May 2011 10:28:17 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
        security@kernel.org, kees@ubuntu.com,
        Tavis Ormandy <taviso@cmpxchg8b.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [Security] Fwd: Oops (bad memory deref) in slab_alloc() due to
 filp_cachep holding incorrect values
Message-ID: <20110525152817.GC3507@mail.hallyn.com>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
 <BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
 <alpine.DEB.2.00.1105231133580.29047@router.home>
 <BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
 <BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
 <BANLkTikp4VweUE+JrkXRSJ-8kEEcPKpw8g@mail.gmail.com>
 <BANLkTimB6pQyux4XEqqEUvuPGsZ2Bw0L8w@mail.gmail.com>
 <20110525144400.GA26206@mail.hallyn.com>
 <BANLkTi=Y_+UBWGb5Kj9ga_bC0Fm7DosGVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=Y_+UBWGb5Kj9ga_bC0Fm7DosGVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Święcki (robert@swiecki.net):
> >> Given that it doesn't seem to appear in 2.6.39-rc4, and judging by the
> >> names of functions involved, this change looks suspiciously related to
> >> this oops (even if it just made the keyctl problem visible)
> >> http://git.itanic.dy.fi/?p=linux-stable;a=commitdiff;h=47a150edc2ae734c0f4bf50aa19499e23b9a46f8
> >>
> >> >> #include <sys/stat.h>
> >> >> #include <sys/wait.h>
> >> >> #include <unistd.h>
> >> >> #include <sys/syscall.h>
> >> >> #include <linux/keyctl.h>
> >> >> #include <linux/sched.h>
> >> >>
> >> >> int TH1(void *dummy) {
> >> >>        syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
> >
> > Thanks!
> >
> > Fooi, it looks like all users of cred_alloc_blank() may need to be
> > audited wrt commit 47a150edc2ae734c0f4bf50aa19499e23b9a46f8.
> >
> > Does this fix the bug you're seeing?
> 
> Yup, the kernel survives both the testcase and a short syscall fuzzing
> session. Thanks.

Thanks, Robert.

David, assuming this gets your ack, do you mind pushing this one forward?

thanks,
-serge
