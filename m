Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1CIPfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:35:24 -0500
Received: from smtp.nokia.com ([147.243.1.47]:59956 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab1CIPfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:35:20 -0500
Message-ID: <4D779EC0.5010702@nokia.com>
Date: Wed, 9 Mar 2011 17:37:36 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <Pine.LNX.4.44L0.1103091005570.1965-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103091005570.1965-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.24.199]
X-OriginalArrivalTime: 09 Mar 2011 15:34:56.0455 (UTC) FILETIME=[8AF9BD70:01CBDE6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 05:10 PM, ext Alan Stern wrote:

>> +	case 2:
>> +		/* Raw TOC */
>> +		memset(buf, 0, 37);	/* Header + A0, A1&  A2 descriptors */
>> +		buf[1] = 37;		/* 4 + 3*11 */
>
> There's no reason to do it this way.  The compiler is a lot better than
> you are at addition.  Just put 4 + 3*11 in the assignment statement,
> and in the comment explain what the numbers mean.

OK.

>
>> +		buf[2] = 1;		/* First complete session */
>> +		buf[3] = 2;		/* Last complete session */
>> +
>> +		buf += 4;
>> +		/* A0 point */
>> +		buf[0] = 1;		/* Session number */
>> +		buf[1] = 0x16;		/* Data track, copying alowed */
>> +		/* 2 - Track number 0 ->  TOC */
>> +		buf[3] = 0xA0;		/* Point A0 */
>> +		/* 4, 5, 6 - Min, sec, frame is zero */
>> +		/* 7 - zero */
>> +		buf[8] = 1;		/* Pmin: 1st track number */
>> +		/* 9 - disc type 0: CD-ROM/DA with 1st track in mode 1 */
>> +		/* 10 - pframe 0 */
>> +
>> +		buf += 11;
>> +		/* A1 point*/
>> +		buf[0] = 1;		/* Session number */
>> +		buf[1] = 0x16;		/* Data track, copying alowed */
>> +		/* 2 - Track number 0 ->  TOC */
>> +		buf[3] = 0xA1;		/* Point A1 */
>> +		/* 4, 5, 6 - Min, sec, frame is zero */
>> +		/* 7, zero */
>> +		buf[8] = 1;		/* Pmin: last track number */
>> +		/* 9, 10 - pmin and pframe are 0 */
>> +
>> +		buf += 11;
>> +		/* A2 point*/
>> +		buf[0] = 1;		/* Session number */
>> +		buf[1] = 0x16;		/* Data track, copying alowed */
>> +		/* 2 - Track number 0 ->  TOC */
>> +		buf[3] = 0xA2;		/* Point A2 */
>> +		/* 4, 5, 6 - Min, sec, frame is zero */
>> +		/* 7, 8, 9, 10 - zero, Pmin, Psec, Pframe of Lead out */
>> +		store_cdrom_address(&buf[7], msf, curlun->num_sectors);
>
> These things could be put into a loop, instead of a separate function.

Yes loop is better than function for this case.

>
>> +		return 37;
>
> It might be a good idea to use a variable instead of having all these
> "37"s floating around.  It would make future updates more reliable.

OK.

-- 
regards,
-roger
