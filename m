Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0IJPDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:03:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60886 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0IJPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:03:48 -0400
Message-ID: <4C8A4871.9040103@oracle.com>
Date: Fri, 10 Sep 2010 08:02:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Joey Lee <jlee@novell.com>
CC: mjg@redhat.com, mjg59@srcf.ucam.org, gregkh@suse.de, trenn@suse.de,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dennis.Jansen@web.de
Subject: Re: [PATCH] Add Intel Poulsbo Stub Driver
References: <4C8A4285020000230002020B@novprvlin0050.provo.novell.com>
In-Reply-To: <4C8A4285020000230002020B@novprvlin0050.provo.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/10 21:36, Joey Lee wrote:
>>> +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
>>> +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
>>> +        select ACPI_VIDEO if ACPI
>>
>> What does it do when ACPI is not enabled?  Does the driver even build
>> when APCI is not enabled?  (given the acpi_video* calls in it)
>>
> 
> This driver will not do anything if API is not enabled. It only call
> acpi_video_register/acpi_video_unregister, and acpi/video.h handle it
> like the following:
> 
> #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> extern int acpi_video_register(void);
> extern void acpi_video_unregister(void);
> extern int acpi_video_get_edid(struct acpi_device *device, int type,
>                                int device_id, void **edid);
> #else
> static inline int acpi_video_register(void) { return 0; }
> static inline void acpi_video_unregister(void) { return; }
> static inline int acpi_video_get_edid(struct acpi_device *device, int
> type,
>                                       int device_id, void **edid)
> {
>         return -ENODEV;
> }
> #endif
> 
> So, I think don't need add "depends on ACPI_VIDEO". How do you think?

Yes, OK, I see.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
