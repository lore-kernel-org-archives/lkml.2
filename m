Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0CPUos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab0CPUop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:44:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>
	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
	<4B957122.4060007@msgid.tls.msk.ru>
	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
	<4B957AF3.6040801@msgid.tls.msk.ru>
	<4B957D20.4010904@msgid.tls.msk.ru>
	<x49wrxij11s.fsf@segfault.boston.devel.redhat.com>
	<4B994022.6030703@msgid.tls.msk.ru>
	<4B994888.8020007@msgid.tls.msk.ru>
	<x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>
	<4B994EFE.70005@msgid.tls.msk.ru>
	<x49d3z4t7yt.fsf@segfault.boston.devel.redhat.com>
	<4B9FEBB0.4020300@msgid.tls.msk.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Mar 2010 16:44:40 -0400
In-Reply-To: <4B9FEBB0.4020300@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Tue, 16 Mar 2010 23:36:00 +0300")
Message-ID: <x498w9st2rr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Jeff Moyer wrote:
> []
>> Sorry for taking so long on this.  I only tested the case where niovs >
>> fast_segs, and I missed an obvious thing: I didn't assign the return
>> pointer to the proper iovec.
>
> There's no need to be sorry really.  Because, well, the whole thing isn't
> quite useful anyway: running proper 64bit code is preferable ;)
>
> I actually tried the thing, running a guest right now, which in turn is
> running a quick benchmark and appears to perform quite good at it too.

OK, great.  I'm in the process of unifying the duplicated code, now, so
I might ask for one more sanity check if you have the time and patience
for it.

>> So, this patch should get you going.
>
> Well, I already switched to 64bit kvm binary for my case, and actually
> that one makes alot more sense anyway: there's no conversion like this
> needed, and no 32<=>64bit mode switching either.  (Actually 32bit code
> in this my case is slower elsewhere too).

OK, makes sense, but we should get this right.

> By the way, how about the case when we've several {write,read}v in the
> iocb array?  Will each use the same fast_segs array from the beginning,
> overwriting data of previous iocb element? :)  Just... curious :)

No, each iocb has a built-in iovec which gets specified for the
fast_iov.

> Thank you for your support!
>
> You can add my
> Tested-By: Michael Tokarev <mjt@tls.msk.ru>
> if you want.  Thanks!

Thanks!

-Jeff
