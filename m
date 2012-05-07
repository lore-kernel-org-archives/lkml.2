Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2EGX4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:56:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62739 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2EGX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:56:33 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-01-4fa8613067b3
Message-id: <4FA8612F.70207@samsung.com>
Date: Tue, 08 May 2012 08:56:31 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if
 resume_file is MAJOR:MINOR style
References: <4FA78724.5000401@samsung.com> <201205072139.20129.rjw@sisk.pl>
In-reply-to: <201205072139.20129.rjw@sisk.pl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 04:39 AM, Rafael J. Wysocki wrote:
>> +	/* name_to_dev_t is ineffective if resume_file comes in major:minor
>> +	 * format */
>> +	if (isdigit(resume_file[0]) && resume_wait) {
> 
> The check here is too late.  It should be done before name_to_dev_t() is
> used on resume_file for the first time.
> 

Thanks for comment, I'll pull it up.

>> +		int partno;
>> +		while (!get_gendisk(swsusp_resume_device, &partno))
>> +			msleep(10);
>> +	}
>> +
>>   Check_image:
>>  	pr_debug("PM: Hibernation image partition %d:%d present\n",
>>  		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
> 
> Besides, I'd like the documentation to be updated to reflect this change too.

Do you mean resumewait is needed to be updated in kernel-parameters.txt?


