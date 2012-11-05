Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2KEI2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:28:33 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41321 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab2KEI2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:28:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUYAMN3l1B5LLsn/2dsb2JhbABEhS64DoR3AoEKgQmCHgEBBTocIxAIAxguFCUDIROICbk4FIttggiENAOVepBFgwM
Date: Mon, 5 Nov 2012 19:28:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: Re: VFS hot tracking: How to calculate data temperature?
Message-ID: <20121105082828.GJ29378@dastard>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
 <CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
 <1351891622.23963.4.camel@oc2046235844.ibm.com>
 <CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 10:35:50AM +0800, Zhi Yong Wu wrote:
> On Sat, Nov 3, 2012 at 5:27 AM, Mingming.cao <cmm@us.ibm.com> wrote:
> > On Fri, 2012-11-02 at 14:38 +0800, Zhi Yong Wu wrote:
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
> >>
> >>
> >
> > Maybe could save the last file temperature with extended attributes.
> It seems that only ext4 has the concept of extended attributes.

All major filesystems have xattr support. They are used extensively
by the security and integrity subsystems, for example.

Saving the information might be something that is useful to certian
applications, but lets have the people that need that functionality
spell out their requirements before discussing how or what to
implement.  Indeed, discussion shoul dreally focus on getting the
core, in-memory infrastructure sorted out first before trying to
expand the functionality further...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
