Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0L1KbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:31:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59772 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0L1KbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mzTdMgt1pEUhjM0DHMAQCNtM58QiJ9JiHRsSwM1qI9A37HgrSdbyS1GpJtpU8yL2Da
         j44FthlILPxv0gWAWsI91a5CbAmQVQcgGhafQh2R+gRqH6CtSZYGpA0BviDM7Ju6oMJh
         n62y79FbxbsKT1oXiPujJpYDGvn5XZJjNFff0=
MIME-Version: 1.0
In-Reply-To: <20101228081917.GA1351@bitwizard.nl>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org>
	<20101228081917.GA1351@bitwizard.nl>
Date: Tue, 28 Dec 2010 12:30:59 +0200
Message-ID: <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com>
Subject: Re: Regular ext4 error warning with HD in USB dock
From: Amir Goldstein <amir73il@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, Con Kolivas <kernel@kolivas.org>,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 10:19 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> On Mon, Dec 27, 2010 at 09:53:43PM -0500, Ted Ts'o wrote:
>> On Tue, Dec 28, 2010 at 09:53:45AM +1100, Con Kolivas wrote:
>> > [1048401.773270] EXT4-fs (sde8): mounted filesystem with writeback data mode.
>> > Opts: (null)
>> > [1048702.736011] EXT4-fs (sde8): error count: 3
>> > [1048702.736016] EXT4-fs (sde8): initial error at 1289053677:
>> > ext4_journal_start_sb:251
>> > [1048702.736018] EXT4-fs (sde8): last error at 1289080948: ext4_put_super:719
>>
>> That's actually not an error.  It's a report which is generated every
>> 24 hours, indicating that there has been 3 errors since the last time
>> the error count has been cleared, with the first error taking place at
>> Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
>> ext4_journal_start_sb(), at line 251, and the most recent error taking
>> place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
>> ext4_put_super() at line 719.  This is a new feature which was added
>> in 2.6.36.
>
> Nice. But the issue you're not mentioning is: What errors could have
> happened on the 6th of november? Should Con worry about those errors?
>

Ted,

I would like to use this opportunity to remind you about my
record_journal_errstr()
implementation, see:
https://github.com/amir73il/ext4-snapshots/blob/next3-stable/fs/next3/super.c#L157

It records the initial errors messages (which I found to be the most
interesting),
in a message buffer on the unused space after the journal super block
(3K on a 4K block fs).

fsck prints out those messages and clears the buffer.
In under a year of Next3 fs in beta and production, it has helped me many times
to analyse bugs post-mortem and find the problem.

If there is demand, I can post the patch for Ext4.

Amir.

> OK, the chances are that he has rebooted since november, and that an
> older fsck fixed the errors, but not cleared the "fs errror log". Would
> these errors have triggered a "remount-readonly" if the fs was mounted
> like that?
>
> I don't reboot that often:
>
> obelix:~> uptime
>  09:16:19 up 175 days, 19:04, 19 users,  load average: 110.10, 110.61, 111.22
>
> (and yes, the load is quite high on that machine. I won't polute this
> thread about that....)
>
>        Roger.
>
> --
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement.
> Does it sit on the couch all day? Is it unemployed? Please be specific!
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
