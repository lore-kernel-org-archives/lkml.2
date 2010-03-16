Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab0CPUgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:36:07 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33696 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab0CPUgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:36:04 -0400
Message-ID: <4B9FEBB0.4020300@msgid.tls.msk.ru>
Date: Tue, 16 Mar 2010 23:36:00 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>	<4B957122.4060007@msgid.tls.msk.ru>	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>	<4B957AF3.6040801@msgid.tls.msk.ru>	<4B957D20.4010904@msgid.tls.msk.ru>	<x49wrxij11s.fsf@segfault.boston.devel.redhat.com>	<4B994022.6030703@msgid.tls.msk.ru>	<4B994888.8020007@msgid.tls.msk.ru>	<x49eijqiqcd.fsf@segfault.boston.devel.redhat.com>	<4B994EFE.70005@msgid.tls.msk.ru> <x49d3z4t7yt.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49d3z4t7yt.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
[]
> Sorry for taking so long on this.  I only tested the case where niovs >
> fast_segs, and I missed an obvious thing: I didn't assign the return
> pointer to the proper iovec.

There's no need to be sorry really.  Because, well, the whole thing isn't
quite useful anyway: running proper 64bit code is preferable ;)

I actually tried the thing, running a guest right now, which in turn is
running a quick benchmark and appears to perform quite good at it too.

> So, this patch should get you going.

Well, I already switched to 64bit kvm binary for my case, and actually
that one makes alot more sense anyway: there's no conversion like this
needed, and no 32<=>64bit mode switching either.  (Actually 32bit code
in this my case is slower elsewhere too).

By the way, how about the case when we've several {write,read}v in the
iocb array?  Will each use the same fast_segs array from the beginning,
overwriting data of previous iocb element? :)  Just... curious :)

Thank you for your support!

You can add my
Tested-By: Michael Tokarev <mjt@tls.msk.ru>
if you want.  Thanks!

/mjt
