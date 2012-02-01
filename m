Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2BAXS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:18:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33702 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2BAXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk> <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org> <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org> <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 15:18:05 -0800
X-Google-Sender-Auth: yybVqAkNOS-8MFUtLiOT0epuGB0
Message-ID: <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 3:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> No extra "keep track of inode counts by hand" crap, and no idiotic
> config options that just make it easy to (conditionally) get things
> wrong. Just do it right, and do it *unconditionally* right.

And btw, "nlink shows number of subdirectories" for a directory entry
really *is* right. It's how Unix filesystems work, like it or not.

It's mainly lazy/bad filesystems that set nlink to 1. So the whole
"nlink==1" case is meant for crap like FAT etc, not for a filesystem
that we control and that could easily just do it right.

Which is why I detest that config option. It's as if you were asking the user

 "Do you want to make the sysfs filesystem act like crap filesystems?"

and kernel config time. What kind of inane question is that?

                    Linus
