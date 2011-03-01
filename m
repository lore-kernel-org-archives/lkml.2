Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1CAG6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:58:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61704 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAG6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:58:00 -0500
Message-ID: <4102429DCB2B4B47A4F51ED0B9A62E2B@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>
Cc: <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com> <B85A65D85D7EB246BE421B3FB0FBB593024BF35DEE@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF35DEE@dbde02.ent.ti.com>
Subject: Re: [PATCH v2 02/13] da850: pruss platform specific additions.
Date: Tue, 1 Mar 2011 12:29:28 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can we not have the PRU UIO also as a part of the MFD framework.
I know that the UIO is not really a device, but I feel its incorrect to 
register the same device twice.
Instead we can have a single entry as the MFD framework and the UIO, as a 
child device, based upon the MFD driver APIs.

All that we need to do is add an entry into the da8xx_pruss_devices 
structure
and the MFD driver will do the rest to get the UIO probe called.

--------------------------------------------------
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
Sent: Monday, February 28, 2011 6:34 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>; 
<davinci-linux-open-source@linux.davincidsp.com>
Cc: <sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; "open list" 
<linux-kernel@vger.kernel.org>; "Watkins, Melissa" <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 02/13] da850: pruss platform specific additions.

> Hi,
>
>> -----Original Message-----
>> From: davinci-linux-open-source-bounces@linux.davincidsp.com
>> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>> Of Subhasish Ghosh
>> Sent: Friday, February 11, 2011 8:21 PM
>> To: davinci-linux-open-source@linux.davincidsp.com
>> Cc: sachi@mistralsolutions.com; Russell King; Kevin Hilman; Subhasish
>> Ghosh; open list; Watkins, Melissa; linux-arm-kernel@lists.infradead.org
>> Subject: [PATCH v2 02/13] da850: pruss platform specific additions.
>>
>> This patch adds the platform device and assignes the platform resources
>> for the PRUSS mfd driver.
>>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>> ---
>> +struct platform_device da8xx_pruss_dev = {
> Can you please rename this to da8xx_pruss_mfddev?
>> + .name = "da8xx_pruss",
> Can you please rename name string as pruss_mfd? This will help to
> base my UIO patches on top of yours.
>> + .id = -1,
>> + .num_resources = ARRAY_SIZE(da8xx_pruss_resources),
>> + .resource = da8xx_pruss_resources,
>> +};
>> +
>> +int __init da8xx_register_pruss(struct da8xx_pruss_devices 
>> *pruss_device)
> Please rename this to da8xx_register_pruss_mfd
>
> Thanks,
> Pratheesh 

