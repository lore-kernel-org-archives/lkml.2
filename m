Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2A1KWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 05:22:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57405 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2A1KWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 05:22:17 -0500
Message-ID: <4F23CC53.4040304@redhat.com>
Date: Sat, 28 Jan 2012 11:22:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.scsi
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Re: Ioctl warning for a partition
References: <20120126223037.GE28368@quack.suse.cz> <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com> <4F21E828.8090502@msgid.tls.msk.ru> <20120127192817.GB25348@khazad-dum.debian.net>
In-Reply-To: <20120127192817.GB25348@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 08:28 PM, Henrique de Moraes Holschuh wrote:
> Does that fix still need to be backported to -stable?
>
> Linux v3.0.18 + Debian stable userspace (mdadm v3.1.4) causes this on
> boot (when mdadm runs in the initramfs):
>
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!

The warnings are intended; the kernel will behave as before they were 
introduced.  I'm monitoring reports and looking at them as they come in. 
  They are harmless as long as the ioctls have always failed, and so far 
this has always been the case.  As soon as we are reasonably certain, 
the warnings will go away.

Paolo
