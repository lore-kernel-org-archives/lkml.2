Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2LCWfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:35:16 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63717 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2LCWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:35:14 -0500
MIME-Version: 1.0
In-Reply-To: <874nk2u69u.fsf@silenus.orebokech.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
 <874nk2u69u.fsf@silenus.orebokech.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 14:34:53 -0800
X-Google-Sender-Auth: cw1Xz_DBW6vfOFJ6JuFPJa05ljw
Message-ID: <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
To: Romain Francoise <romain@orebokech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 2:20 PM, Romain Francoise <romain@orebokech.com> wrote:
>
> Could these changes be the reason for the following suddenly appearing in
> one of my VMs with rc8 (no such messages with rc7)? Pretty standard virtio
> setup in KVM.
>
> [   11.832295] attempt to access beyond end of device
> [   11.832298] vda1: rw=0, want=4192904, limit=4192902
> [   11.832299] Buffer I/O error on device vda1, logical block 524112
> [   11.832394] attempt to access beyond end of device
> [   11.832395] vda1: rw=0, want=4192904, limit=4192902
> [   11.832396] Buffer I/O error on device vda1, logical block 524112

Yup.

I'm currently debating whether I should just remove the printk (for
3.8) or actually do the iovec truncation by hand. The "remove the
printk" is a bit cheesy, but I suspect it's the simpler/safer
alternative.

Just for info, can you add a "WARN_ON_ONCE()" to handle_bad_sector()
just so that I see which particular path your kvm load triggers.

          Linus
