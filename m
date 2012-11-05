Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2KEMSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:18:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47459 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2KEMSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <1352116672.2705.16.camel@menhir>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<1351891622.23963.4.camel@oc2046235844.ibm.com>
	<CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
	<20121105082828.GJ29378@dastard>
	<CAEH94LhbiHdsTCzsH6K8g3WH02_5-dnUPRZBCJW9vtpgAuuGtg@mail.gmail.com>
	<1352111588.2705.7.camel@menhir>
	<CAEH94Lj6ZJ=8WWAaEMxJqFt8AvbQJiia0cptC=-DZca74fcFaw@mail.gmail.com>
	<1352116672.2705.16.camel@menhir>
Date: Mon, 5 Nov 2012 20:18:35 +0800
Message-ID: <CAEH94LhgD_Rd=cNTwjWEVbyurGXxhPr5wNb6P9xSiThbN7n4Dw@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 7:57 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Mon, 2012-11-05 at 19:46 +0800, Zhi Yong Wu wrote:
>> On Mon, Nov 5, 2012 at 6:33 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>> > Hi,
>> >
>> > On Mon, 2012-11-05 at 16:44 +0800, Zhi Yong Wu wrote:
>> >> On Mon, Nov 5, 2012 at 4:28 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Mon, Nov 05, 2012 at 10:35:50AM +0800, Zhi Yong Wu wrote:
>> >> >> On Sat, Nov 3, 2012 at 5:27 AM, Mingming.cao <cmm@us.ibm.com> wrote:
>> >> >> > On Fri, 2012-11-02 at 14:38 +0800, Zhi Yong Wu wrote:
>> >> >> >> Here also has another question.
>> >> >> >>
>> >> >> >> How to save the file temperature among the umount to be able to
>> >> >> >> preserve the file tempreture after reboot?
>> >> >> >>
>> >> >> >> This above is the requirement from DB product.
>> >> >> >> I thought that we can save file temperature in its inode struct, that
>> >> >> >> is, add one new field in struct inode, then this info will be written
>> >> >> >> to disk with inode.
>> >> >> >>
>> >> >> >> Any comments or ideas are appreciated, thanks.
>> >> >> >>
>> >> >> >>
>> >> >> >
>> >> >> > Maybe could save the last file temperature with extended attributes.
>> >> >> It seems that only ext4 has the concept of extended attributes.
>> >> >
>> >> > All major filesystems have xattr support. They are used extensively
>> >> > by the security and integrity subsystems, for example.
>> >> got it, thanks.
>> >> >
>> >> > Saving the information might be something that is useful to certian
>> >> > applications, but lets have the people that need that functionality
>> >> > spell out their requirements before discussing how or what to
>> >> > implement.  Indeed, discussion shoul dreally focus on getting the
>> >> > core, in-memory infrastructure sorted out first before trying to
>> >> > expand the functionality further...
>> >> ah, but the latest patchset need some love from experienced FS guys:).......
>> >
>> > There is one other possible issue with saving the data into the
>> > filesystem, which is that it may disturb what you are trying to measure.
>> > Some filesystems (GFS2 is one) store data for small inodes in the same
>> > block as the inode itself. So that means the accesses to the saved hot
>> > tracking info may potentially affect the data access times too. Also
>> > there is a very limited amount of space to expand the number of fields
>> > in the inode, so xattr may be the only solution, depending on how much
>> > data needs to be stored in each case.
>> Very good analysis, two possible issues are very meanful, thanks.
>> >
>> > In the GFS2 case (I don't think it is unique in this) xattrs are stored
>> > out of line and having to access them in every open means an extra block
>> > read per inode, which again has performance implications.
>> >
>> > So that is not an insurmountable problem, but something to take into
>> > account in selecting a solution,
>> In summary, you look like preferring to xattr as its solution.
>>
>
> Well, that depends on exactly how large the data to be stored is, and
> other factors. It will add overhead to the storage/retrieval but at
> least it is fairly generic (wrt on-disk format) so likely to be easier
> to retrofit to existing filesystems.
Do you have some idea with more details about how to retrofit to existing FS?:)
>
> I suspect this may be one of those cases where there is no obvious right
> answer and it is a case of selecting the least worst option, if that
> makes sense?
Then we can only check which solution is better via large scale
performance test.
>
> Steve.
>
>



-- 
Regards,

Zhi Yong Wu
