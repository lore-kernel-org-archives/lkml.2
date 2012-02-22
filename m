Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2BVEUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:20:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58001 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab2BVEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:20:15 -0500
X-Sasl-enc: cUMNeD4DthQyf9U6T+P3LhLNgOlAmIa8MdkoI6yoqcGA2U4Lq8FHL4jBjg 1329884413
Message-ID: <1329884410.2193.29.camel@perseus.themaw.net>
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, autofs@linux.kernel.org, thomas@m3y3r.de,
        viro@zeniv.linux.org.uk
Date: Wed, 22 Feb 2012 12:20:10 +0800
In-Reply-To: <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	 <20120221.221609.218135609185671883.davem@davemloft.net>
	 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 19:47 -0800, Linus Torvalds wrote:
> On Tue, Feb 21, 2012 at 7:33 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But I'm sure that the autofs daemon does something simple that we can
> > depend on in practice.
> 
> I didn't find the most recent source code, but the first thing that
> automount.c does after calling "mount" (which is a for+exec, so we
> cannot take the mounting is_compat_task() into account is to open the
> new root for the ioctlfd, and then it does a stat.
> 
> And then it does a AUTOFS_IOC_PROTOVER ioctl to see what the protocol
> version is.
> 
> So we could just decide that
> 
>  (a) we add a mount option for the packet size (or just "v6" - which
> would be "v5 with a fixed packet size")
> 
>  (b) in the absence of an explicit mount option, we look at
> is_compat_task() for the first AUTOFS_IOC_PROTOVER ioctl we get.
> 
> That looks fairly straightforward and safe. Hmm?
> 
> Where are the automount sources supposed to be, anyway? kernel.org has
> a v5 directory, but it's empty.

I'm repopulating the autofs directory with content right now.
I had some difficulty with getting appropriate signatures for my PGP
key, consequently my account wasn't activated for quite. The upshot of
that is I wasn't aware of announcements about kup either. Anyway, I've
sorted that out and I'm trying to upload the content right now. 

The git repo has been available for a while now though @
/pub/scm/linux/kernel/git/raven/autofs

at least that is the place I thought it should go?
Ian


