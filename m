Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2LCXOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:14:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46121 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2LCXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:14:46 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
 <874nk2u69u.fsf@silenus.orebokech.com> <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
 <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com> <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 15:14:25 -0800
X-Google-Sender-Auth: mgdI91VoVGjTj2Ks2Esm_wd1AV4
Message-ID: <CA+55aFzvDC+HenBX4Arn-xHernNoLkxpYrjWov+k09K_qT78vQ@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
To: Tony Luck <tony.luck@intel.com>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 3:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I guess I need to try harder. I'm guessing that there's a 4kB
> filesystem there, and the block device size isn't 4kB-aligned or
> something.

Anyway, to clarify: the printk's are harmless, since the IO past the
end of the device is just error'ed out, and always has been.  Which is
why I was considering just removing them.

At the same time, those printk's have historically been useful for
finding unrelated bugs (ie filesystem corruption etc that causes
insane accesses) and there is the issue of the difference between EOF
and EIO return values, so I've been trying to trigger this for normal
read/writes to make sure that there wasn't anything going on there.
All of the paths I've looked at seem to look at the inode size, but
clearly I missed some.

I bet it's read-ahead together with something particular that allows
you to trigger it.

              Linus
