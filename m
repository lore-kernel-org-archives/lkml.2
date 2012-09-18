Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2IRCY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 22:24:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46925 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2IRCY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 22:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120917213009.GH13691@dastard>
References: <1347866325-25979-1-git-send-email-zwu.kernel@gmail.com>
	<20120917213009.GH13691@dastard>
Date: Tue, 18 Sep 2012 10:24:55 +0800
Message-ID: <CAEH94LgfxDa2=TubEFcDAyPD=UPfa2yJ-y0Rn7Dto6zs90xScw@mail.gmail.com>
Subject: Re: [RFC v1 00/11] vfs: hot data tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, cmm@us.ibm.com,
        tytso@mit.edu, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:30 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Sep 17, 2012 at 03:18:34PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> NOTE:
>>
>>   The patchset is currently post out mainly to make sure
>> it is going in the correct direction and hope to get some
>> helpful comments from other guys.
>>
>> TODO List:
>>
>>  1.) Need to do scalability or performance tests.
>>  2.) Turn some Micro into tunables
>>        TIME_TO_KICK, and HEAT_UPDATE_DELAY
>>  3.) Rafactor hot_hash_is_aging()
>>        If you just made the timeout value a timespec and compared
>>      the _timespecs_, you would be doing a lot fewer conversions.
>>  4.) Cleanup some unnecessary lock protect
>>  5.) Add more comments to explain how to calc temperature
>
> 0) Documentation.
>
>> Zhi Yong Wu (11):
>>   vfs: introduce one structure hot_info
>>   vfs: introduce one rb tree - hot_inode_tree
>>   vfs: introduce 2 rb tree items - inode and range
>
> These three patches can probably just be flattened into one.
> Splitting out the first two doesn't add to the clarity of the
> series - add the structures in the patch that actually uses them
> so we don't ahve to jump between patches to see how they are used.
It make sense to me, OK, thanks.
>
>>   vfs: add support for updating access frequency
>>   vfs: add one new mount option '-o hottrack'
>>   vfs: add init and exit support
>>   vfs: introduce one hash table
>>   vfs: enable hot data tracking
>>   vfs: fork one private kthread to update temperature info
>>   vfs: add 3 new ioctl interfaces
>>   vfs: add debugfs support
>>
>>  fs/Makefile               |    3 +-
>>  fs/compat_ioctl.c         |    8 +
>>  fs/dcache.c               |    2 +
>>  fs/direct-io.c            |   10 +
>>  fs/hot_debugfs.c          |  487 ++++++++++++++++++++++++++++++++++
>>  fs/hot_debugfs.h          |   60 +++++
>>  fs/hot_hash.c             |  369 ++++++++++++++++++++++++++
>>  fs/hot_hash.h             |  108 ++++++++
>>  fs/hot_rb.c               |  648 +++++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_rb.h               |   70 +++++
>>  fs/hot_track.c            |  113 ++++++++
>>  fs/hot_track.h            |   23 ++
>>  fs/ioctl.c                |  132 +++++++++
>>  fs/namespace.c            |   10 +
>>  fs/super.c                |   11 +
>>  include/linux/fs.h        |   15 +
>>  include/linux/hot_track.h |  169 ++++++++++++
>>  mm/filemap.c              |    8 +
>>  mm/page-writeback.c       |   21 ++
>>  mm/readahead.c            |    9 +
>>  20 files changed, 2275 insertions(+), 1 deletions(-)
>>  create mode 100644 fs/hot_debugfs.c
>>  create mode 100644 fs/hot_debugfs.h
>>  create mode 100644 fs/hot_hash.c
>>  create mode 100644 fs/hot_hash.h
>>  create mode 100644 fs/hot_rb.c
>>  create mode 100644 fs/hot_rb.h
>>  create mode 100644 fs/hot_track.c
>>  create mode 100644 fs/hot_track.h
>>  create mode 100644 include/linux/hot_track.h
>
> So, 9 new files for tracking all of this? I'm not sure that so
> many new files are needed - putting it all in fs/hot_tracking.[ch]
> might make more sense, or if all 8 fs/hot* files remain, putting
> them in their own subdirectory might be an idea (like quota).
If all functions are in two files, they will be large and the logic is
not so clear. so i prefer the latter. thanks.
>
> I'll comment on the code when I get a bit of time to look at it.
Great, very look forward to your more comments.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
