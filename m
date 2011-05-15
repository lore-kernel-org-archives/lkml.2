Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab1EOQ4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:56:34 -0400
Received: from to5email.gprs.rogers.com ([74.198.8.2]:45232 "EHLO
	to5email1.gprs.rogers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193Ab1EOQ4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:56:33 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 12:56:32 EDT
References: <367853.39582.qm@web130121.mail.mud.yahoo.com> <m2k4dsnghx.fsf@firstfloor.org>
In-Reply-To: <m2k4dsnghx.fsf@firstfloor.org>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <AA3F896F-8054-4981-8D43-A48A76C0087E@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Mailer: iPhone Mail (8J2)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Possible coding issue in udf??
Date: Sun, 15 May 2011 10:32:11 -0600
To: Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-15, at 9:14 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Alex Davis <alex14641@yahoo.com> writes:
>> In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:
>> 
>>    udfperms = ((inode->i_mode & S_IRWXO)) |
>>           ((inode->i_mode & S_IRWXG) << 2) |
>>           ((inode->i_mode & S_IRWXU) << 4);
>> 
>> Shouldn't we be shifting by 3 bits? i.e:
>>    udfperms = ((inode->i_mode & S_IRWXO)) |
>>           ((inode->i_mode & S_IRWXG) << 3) |
>>           ((inode->i_mode & S_IRWXU) << 6);
>> 
>> The S_I.. constants are all defined in include/linux/stat.h as 3-bit values.
>> 
>> I will send a patch if needed.
> 
> I  would suggest you test it first. Put in a UDF disk that triggers
> this case (verify with a printk). Check in ls -l if the 
> permissions are correct or wrong.

Typically I would agree. In this case ir looks like the existing code doesn't make sense, because it will be overlapping the R and X bits from the adjacent U, G, and O masks. 

Cheers, Andreas