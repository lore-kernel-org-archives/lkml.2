Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab2KFJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:00:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43985 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2KFJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:00:22 -0500
MIME-Version: 1.0
In-Reply-To: <20121106083918.GA6090@gmail.com>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<20121102084109.GA19753@gmail.com>
	<CAEH94LiYoeJEDxuHtK=z1sA5h7kzZQ1Day+U5o1SZDz-m8RYnA@mail.gmail.com>
	<20121106083918.GA6090@gmail.com>
Date: Tue, 6 Nov 2012 17:00:19 +0800
Message-ID: <CAEH94Li_9VfDKoFDjxZv3cjs3wn2p_dfJmnCyRbynku6EDSeHQ@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>, linux-fsdevel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, Dave Chinner <david@fromorbit.com>,
        cmm@us.ibm.com, Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 4:39 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, Nov 05, 2012 at 10:29:39AM +0800, Zhi Yong Wu wrote:
>> On Fri, Nov 2, 2012 at 4:41 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>> > On Fri, Nov 02, 2012 at 02:38:29PM +0800, Zhi Yong Wu wrote:
>> >> Here also has another question.
>> >>
>> >> How to save the file temperature among the umount to be able to
>> >> preserve the file tempreture after reboot?
>> >>
>> >> This above is the requirement from DB product.
>> >> I thought that we can save file temperature in its inode struct, that
>> >> is, add one new field in struct inode, then this info will be written
>> >> to disk with inode.
>> >>
>> >> Any comments or ideas are appreciated, thanks.
>> >
>> > Hi Zhiyong,
>> >
>> > I think that we might define a callback function.  If a filesystem wants
>> > to save these data, it can implement a function to save them.  The
>> > filesystem can decide whether adding it or not by themselves.
>> Great idea,  temperature saving function is maybe very specific to FS.
>> But i am wondering if we can find one generic way to save temperature
>> info at first.
>
> I don't think a generic way is better because it cannot support a
> variety of filesystems.  So maybe you must answer this question firstly:
> how many filesystems do you want to save this info? such as ext4, xfs,
> btrfs, etc.  Then we can try to find a generic way.  If only these three
> filesystems you want to support, maybe saving in xattr is an optional
> way.
yes, xattr is one good choice from currect discussion result. Maybe we
can provide one generic way, and one callback registering
infrastructure, if FS register its own saving callback, this callback
function will be used, otherwise the generic way will be applied.

By the way, as what Dave mentioned, the patchset v4+ review has
highest priority, then the way how to calc data temperature, and the
lowest priority is the way how to save data temperature info.

>
> Regards,
> Zheng



-- 
Regards,

Zhi Yong Wu
