Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab2KGGd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:33:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34130 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2KGGdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:33:25 -0500
Date: Wed, 7 Nov 2012 14:45:44 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: Re: VFS hot tracking: How to calculate data temperature?
Message-ID: <20121107064544.GB7086@gmail.com>
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
 <20121106083918.GA6090@gmail.com>
 <CAEH94Li_9VfDKoFDjxZv3cjs3wn2p_dfJmnCyRbynku6EDSeHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94Li_9VfDKoFDjxZv3cjs3wn2p_dfJmnCyRbynku6EDSeHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 05:00:19PM +0800, Zhi Yong Wu wrote:
> On Tue, Nov 6, 2012 at 4:39 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Mon, Nov 05, 2012 at 10:29:39AM +0800, Zhi Yong Wu wrote:
> >> On Fri, Nov 2, 2012 at 4:41 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> >> > On Fri, Nov 02, 2012 at 02:38:29PM +0800, Zhi Yong Wu wrote:
> >> >> Here also has another question.
> >> >>
> >> >> How to save the file temperature among the umount to be able to
> >> >> preserve the file tempreture after reboot?
> >> >>
> >> >> This above is the requirement from DB product.
> >> >> I thought that we can save file temperature in its inode struct, that
> >> >> is, add one new field in struct inode, then this info will be written
> >> >> to disk with inode.
> >> >>
> >> >> Any comments or ideas are appreciated, thanks.
> >> >
> >> > Hi Zhiyong,
> >> >
> >> > I think that we might define a callback function.  If a filesystem wants
> >> > to save these data, it can implement a function to save them.  The
> >> > filesystem can decide whether adding it or not by themselves.
> >> Great idea,  temperature saving function is maybe very specific to FS.
> >> But i am wondering if we can find one generic way to save temperature
> >> info at first.
> >
> > I don't think a generic way is better because it cannot support a
> > variety of filesystems.  So maybe you must answer this question firstly:
> > how many filesystems do you want to save this info? such as ext4, xfs,
> > btrfs, etc.  Then we can try to find a generic way.  If only these three
> > filesystems you want to support, maybe saving in xattr is an optional
> > way.
> yes, xattr is one good choice from currect discussion result. Maybe we
> can provide one generic way, and one callback registering
> infrastructure, if FS register its own saving callback, this callback
> function will be used, otherwise the generic way will be applied.
> 
> By the way, as what Dave mentioned, the patchset v4+ review has
> highest priority, then the way how to calc data temperature, and the
> lowest priority is the way how to save data temperature info.

Great!  Thanks for sharing the news with me.  IMHO the highest priority
is that we must know the overhead that this patch set costs after using
these patches.  My point of view is that there is no any overhead when
it is disabled, and it only brings a little overhead when it is enabled.

Regards,
Zheng
