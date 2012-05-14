Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2ENAxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 20:53:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60945 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2ENAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 20:53:07 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-43-4fb05771686a
Message-id: <4FB05770.3050809@samsung.com>
Date: Mon, 14 May 2012 09:53:04 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernate : Use get_gendisk to verify partition if
 resume_file is integer format
References: <4FAA4597.7060302@samsung.com> <201205122339.01696.rjw@sisk.pl>
In-reply-to: <201205122339.01696.rjw@sisk.pl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 06:39 AM, Rafael J. Wysocki wrote:
> On Wednesday, May 09, 2012, Minho Ban wrote:
>>  	/* Check if the device is there */
>>  	swsusp_resume_device = name_to_dev_t(resume_file);
>> +
>> +	/*
>> +	 * name_to_dev_t is ineffective to verify parition if resume_file is in
>> +	 * integer format. (e.g. major:minor)
>> +	 */
>> +	if (isdigit(resume_file[0]) && resume_wait) {
>> +		int partno;
>> +		while (!get_gendisk(swsusp_resume_device, &partno))
>> +			msleep(10);
>> +	}
> 
> Hmm.  Wouldn't it be better to do:
> 
> 	if (isdigit(resume_file[0]) && resume_wait) {
> 		int partno;
> 		while (!get_gendisk(swsusp_resume_device, &partno))
> 			msleep(10);
> 	} else {
> 		swsusp_resume_device = name_to_dev_t(resume_file);
> 	}
> 
> ?

Do you want name_to_dev_t to be called again?  If not, swsusp_resume_device parameter 
in get_gendisk can not be used because it is not initialized yet.

> 
> Your new code will overwrite whatever swsusp_resume_device is set to by the
> preceding statement anyway.
> 

Sorry, I don't understand what will be overwritten by the new code. It would be very 
much appreciated if you point it again.

Regards,
Minho Ban
