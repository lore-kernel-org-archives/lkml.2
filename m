Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2JGGU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 02:20:58 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55797 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2JGGU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 02:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <1349552441.12699.115.camel@kjgkr>
References: <20121006071905.GA28760@stefanha-thinkpad>
	<1349552441.12699.115.camel@kjgkr>
Date: Sun, 7 Oct 2012 08:20:55 +0200
Message-ID: <CAJSP0QXn=_zJdVoqfWVxvzyodRZXeXMD67s=+7LwbFyL42ijGg@mail.gmail.com>
Subject: Re: [PATCH 01/16] f2fs: add document
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 9:40 PM, Jaegeuk Kim <jaegeuk.kim@gmail.com> wrote:
> 2012-10-06 (토), 09:19 +0200, Stefan Hajnoczi:
>> > This adds a document describing the mount options, proc entries, usage, and
>> > design of Flash-Friendly File System, namely F2FS.
>> >
>> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim <at> samsung.com>
>> > ---
>> >  Documentation/filesystems/00-INDEX |    2 +
>> >  Documentation/filesystems/f2fs.txt |  314 ++++++++++++++++++++++++++++++++++++
>> >  2 files changed, 316 insertions(+)
>> >  create mode 100644 Documentation/filesystems/f2fs.txt
>> >
>> > diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
>> > index 8c624a1..ce5fd46 100644
>> > --- a/Documentation/filesystems/00-INDEX
>> > +++ b/Documentation/filesystems/00-INDEX
>> > @@ -48,6 +48,8 @@ ext4.txt
>> >     - info, mount options and specifications for the Ext4 filesystem.
>> >  files.txt
>> >     - info on file management in the Linux kernel.
>> > +f2fs.txt
>> > +   - info and mount options for the F2FS filesystem.
>> >  fuse.txt
>> >     - info on the Filesystem in User SpacE including mount options.
>> >  gfs2.txt
>> > diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
>> > new file mode 100644
>> > index 0000000..cd3f846
>> > --- /dev/null
>> > +++ b/Documentation/filesystems/f2fs.txt
>> > @@ -0,0 +1,314 @@
>> > +================================================================================
>> > +WHAT IS Flash-Friendly File System (F2FS)?
>> > +================================================================================
>> > +
>> > +NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
>> > +been widely being used for ranging from mobile to server systems. Since they are
>> > +known to have different characteristics from the conventional rotational disks,
>> > +a file system, an upper layer to the storage device, should adapt to the changes
>> > +from the sketch.
>> > +
>> > +F2FS is a file system exploiting NAND flash memory-based storage devices, which
>> > +is based on Log-structured File System (LFS). The design has been focused on
>> > +addressing the fundamental issues in LFS, which are snowball effect of wandering
>> > +tree and high cleaning overhead.
>> > +
>> > +Since a NAND flash memory-based storage device shows different characteristic
>> > +according to its internal geometry or flash memory management scheme aka FTL,
>> > +F2FS and its tools support various parameters not only for configuring on-disk
>> > +layout, but also for selecting allocation and cleaning algorithms.
>>
>> This is pretty high-level, can you list the main F2FS design points that are
>> optimized for NAND flash characteristics?
>
> Ok, I'll summarize and supplement some major features in v2.

Thanks!

>>
>> First I thought it's log-structured so it automatically performs write
>> wear-leveling.  But F2FS is intended to be used on top of FTL?
>
> Yes, F2FS works on top of FTL. The main goal of f2fs is to produce IOs
> optimized to FTL as a best effort. So, I expect that F2FS would mitigate
> the wear-out problem in FTL helpfully.
>
>>  So the FTL
>> already handles that, and also it appears F2FS is a hybrid between append-only
>> and write in-place.
>
> Yes, F2FS is a hybrid, but in-place-writes will be occurred only when
> there is not enough free space. So normally, it happens append-only.
>
> Anyway, do you concern the trade-off between wear-leveling and
> in-place-writes?
> IMHO, for better wear-leveling in FTL, file system cannot help writing
> data in append-only as much as possible and aligning management units
> between fs and FTL. I think that would be sufficiently effective to
> reduce the wear-leveling overhead.

Okay, thanks for explaining.  Sounds like F2FS makes it easy for the
FTL without taking over the responsibility of wear-leveling
completely.

>>
>> Who will choose "various parameters" and select "allocation and cleaning
>> algorithms" appropriate for the device?
>
> I think that the parameters will be determined mainly by system vendors.
> They select flash chips for products so that they able to know also what
> parameters are preferable from the chip vendor.
> But, I think the default parameters are common enoughly for usual
> environment.

If the default parameters are usually fine then great.  I was thinking
about formatting existing SD cards with F2FS.

Stefan
