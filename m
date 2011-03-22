Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1CVXOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:14:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1CVXOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:14:02 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
Date: Wed, 23 Mar 2011 00:13:41 +0100
User-Agent: KMail/1.9.10
Cc: Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        neilb@suse.de, aufs-users@lists.sourceforge.net,
        sfjro@users.sourceforge.net
References: <20110322152602.053930811@szeredi.hu> <4D88E8EF.8000001@openwrt.org> <AANLkTim-_h9_mp3hPQXndTc3gR+AJKj+keoN2yDZV2Sr@mail.gmail.com>
In-Reply-To: <AANLkTim-_h9_mp3hPQXndTc3gR+AJKj+keoN2yDZV2Sr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201103230013.41936.hpj@urpla.net>
X-Provags-ID: V02:K0:ypgGsHgH3orPJHJEPLNn8r8Q0FnP11HhF18uVSkJhaU
 K+fZn82pbCE88kI5xDrdaxRo9n2m/POYmwfXCKjl6T66OsN8nd
 ri8I/8LgRKyiLw8+DAnSXccasGLVscsoQ4xoknlmv8V7y2TtFA
 IRYrEI3tuo3iLb3fG1oxA/9Ye/8CJxd0h4Jhr+ehVTiZgJfiFA
 f6aiPiVacUuK4h5vGAOOSJW7vkMjuT2QcXKqunt0NM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, 19:49:44 Xianghua Xiao wrote:
> On Tue, Mar 22, 2011 at 1:22 PM, Felix Fietkau <nbd@openwrt.org> 
wrote:
> > On 2011-03-22 6:36 PM, Linus Torvalds wrote:
> >> On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> 
wrote:
> >>> Here's an updated version of the overlay filesystem.  I'd like to
> >>> propose it for inclusion into mainline.
> >>
> >> So on the whole it looked pretty small and simple. And most of the
> >> VFS level changes looked fine and I just reacted to the odd
> >> calling convention for open (I really think you should aim for
> >> ->open to have the basically same arguments as you made
> >> __dentry_open have: 'struct path', 'struct filp' and 'struct
> >> cred').
> >>
> >> But I'd want Al's ack on the series. And also hear who uses it and
> >> how it's been tested?
> >
> > We're using it in OpenWrt (an Embedded Linux distribution) for
> > devices with tiny amounts of flash for the entire system (e.g. 4
> > MB). We're using it to provide a writable on-flash root filesystem
> > with squashfs for the read-only part and jffs2 for the writable
> > overlay. This saves some precious flash space compared to using
> > only jffs2, and it makes it easy for users to reset their device to
> > defaults without having to reflash.
> > With a backport of v6 of this series + my fixes that went into v7
> > this is working quite well on 2.6.37 and 2.6.38 - I'm using it on a
> > few wireless access points at home.
> >
> > - Felix
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
> how is this filesystem related to mini_fo and unionfs?

and aufs2: it's a minimalistic version of a layered filesystem, being 
much less capable then its ancestors, but hopefully the right approach 
to get the foot in the door.. Unfortunately, it's locking out NFS, 
which is a big miss for diskless usage scenarios (where layered 
filesystems are also used commonly since ages..).

Probably, it will grow up, Al gets the VFS sorted out from a FS layering 
perspective, Valerie Aurora and friends get union mounts operating and 
merged, and/or Linus finally merges Junjiro Okajima's aufs2, which is 
often used in production environments today, where other layered 
filesystem approaches are unusable or simply fail in practice.

Btw: Fortunately, Junjiro, being a Tokio habitant, wasn't injured from 
the earth quake nor the tzunami, and let us all pray five minutes for 
success and survival of those brave guys, that try to fix the cooling 
in the Fukushima atomic plant.

Pete
