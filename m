Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab1EORPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:15:55 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59220 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1EORPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:15:53 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Davis <alex14641@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Possible coding issue in udf??
References: <367853.39582.qm@web130121.mail.mud.yahoo.com>
	<m2k4dsnghx.fsf@firstfloor.org>
X-Yow: A KAISER ROLL?!  What good is a Kaiser Roll without a little
 COLE SLAW on the SIDE?
Date: Sun, 15 May 2011 19:15:50 +0200
In-Reply-To: <m2k4dsnghx.fsf@firstfloor.org> (Andi Kleen's message of "Sun, 15
	May 2011 08:14:02 -0700")
Message-ID: <m2liy7evg9.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Alex Davis <alex14641@yahoo.com> writes:
>
>> In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:
>>
>> 	udfperms = ((inode->i_mode & S_IRWXO)) |
>> 		   ((inode->i_mode & S_IRWXG) << 2) |
>> 		   ((inode->i_mode & S_IRWXU) << 4);
>>
>> Shouldn't we be shifting by 3 bits? i.e:
>> 	udfperms = ((inode->i_mode & S_IRWXO)) |
>> 		   ((inode->i_mode & S_IRWXG) << 3) |
>> 		   ((inode->i_mode & S_IRWXU) << 6);
>>
>> The S_I.. constants are all defined in include/linux/stat.h as 3-bit values.
>>
>> I will send a patch if needed.
>
> I  would suggest you test it first. Put in a UDF disk that triggers
> this case (verify with a printk). Check in ls -l if the 
> permissions are correct or wrong.

That's the write part of UDF, so a read-only test won't trigger.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
