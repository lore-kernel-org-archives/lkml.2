Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1CLXjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 18:39:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab1CLXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 18:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=JzIOZVoAQyNrMKrhgc/skHF+tBmep9eHiBxmTrX+BGgsfHybOfRQ5xxANikmvKphpR
         7XqpKpepDB0plC43rZUu15hui+3kHtKYynWMfunY/BHyBTdsLo2xorYt8GY/O1ITuuM9
         xroikgw4IlKdfKVTxzbHRMTO1jyw2V2iYsvqA=
Message-ID: <4D7C0423.9020204@linaro.org>
Date: Sat, 12 Mar 2011 23:39:15 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110312223212.27020.9839.stgit@otae.warmcat.com> <201103130029.38458.rjw@sisk.pl>
In-Reply-To: <201103130029.38458.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2011 11:29 PM, Somebody in the thread at some point said:

Hi -

> On Saturday, March 12, 2011, Andy Green wrote:
>> This structure allows tagging arbitrary platform_data that can't be attached
>> to a device until after it is probed, with the device path name that it is
>> to be attached to.

>> +struct platform_async_platform_data {
>> +	const char *device_path;
>> +	void *platform_data;
>> +};
>> +
>>   #endif /* _PLATFORM_DEVICE_H_ */
>
> Using device paths for this purpose seems to be very fragile to me.  Isn't
> there any better solution?

Given that this targets board definition files which commonly do the 
platform_add_device for the USB bus controller synchronously, and the 
bus-connected devices it is aimed at are soldered on to the board 
connected to specific bus controllers, the bus paths are completely 
deterministic.

-Andy
