Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2KFI06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:26:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49990 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2KFI05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:26:57 -0500
Date: Tue, 6 Nov 2012 16:39:18 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: Re: VFS hot tracking: How to calculate data temperature?
Message-ID: <20121106083918.GA6090@gmail.com>
Mail-Followup-To: Zhi Yong Wu <zwu.kernel@gmail.com>,
	linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
	Ben Chociej <bchociej@gmail.com>,
	James Northrup <northrup.james@gmail.com>,
	linux-kernel mlist <linux-kernel@vger.kernel.org>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
 <CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
 <20121102084109.GA19753@gmail.com>
 <CAEH94LiYoeJEDxuHtK=z1sA5h7kzZQ1Day+U5o1SZDz-m8RYnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94LiYoeJEDxuHtK=z1sA5h7kzZQ1Day+U5o1SZDz-m8RYnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 10:29:39AM +0800, Zhi Yong Wu wrote:
> On Fri, Nov 2, 2012 at 4:41 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Fri, Nov 02, 2012 at 02:38:29PM +0800, Zhi Yong Wu wrote:
> >> Here also has another question.
> >>
> >> How to save the file temperature among the umount to be able to
> >> preserve the file tempreture after reboot?
> >>
> >> This above is the requirement from DB product.
> >> I thought that we can save file temperature in its inode struct, that
> >> is, add one new field in struct inode, then this info will be written
> >> to disk with inode.
> >>
> >> Any comments or ideas are appreciated, thanks.
> >
> > Hi Zhiyong,
> >
> > I think that we might define a callback function.  If a filesystem wants
> > to save these data, it can implement a function to save them.  The
> > filesystem can decide whether adding it or not by themselves.
> Great idea,  temperature saving function is maybe very specific to FS.
> But i am wondering if we can find one generic way to save temperature
> info at first.

I don't think a generic way is better because it cannot support a
variety of filesystems.  So maybe you must answer this question firstly:
how many filesystems do you want to save this info? such as ext4, xfs,
btrfs, etc.  Then we can try to find a generic way.  If only these three
filesystems you want to support, maybe saving in xattr is an optional
way.

Regards,
Zheng
