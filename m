Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1CQUIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab1CQUIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:08:50 -0400
Message-ID: <4D826A4F.9070608@redhat.com>
Date: Thu, 17 Mar 2011 16:08:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com> <20110317193023.GA16790@kroah.com> <4D826718.3030001@redhat.com>
In-Reply-To: <4D826718.3030001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry Greg, I missed replying to one of your questions.

>>   
>>     
>>> +}
>>> +
>>> +/* add additional sysfs files here */
>>> +static struct device_attribute smbios_attrs[] = {
>>> +	__ATTR_RO(version),
>>> +};
>>>     
>>>       
>> So a whole new class just for a single version file in sysfs?
>>
>>     

Right now it is only the version file.  Eventually I was thinking that
this would grow to include sysfs entries for the BIOS info (date,
vendor, etc.) and Product and Chassis info, not to mention all the
various SMBIOS structs.  We have at least one driver that goes through a
lot of trouble to get this info, and IIRC, the PCI code now outputs
type41 and type9 fields for the network device naming stuff.

I thought that meant it needed a new class but, as you pointed out, that
isn't the case.  I'll ping kernel-mentors and see if anyone there might
point me to the right class for this data.

>> I'm confused, what exactly are you trying to show here that you can't
>> show in the existing device/class structure?
>>
>>     

I want to show the version of the SMBIOS on the system.  But it doesn't
seem to make sense to me to expose it in the DMI sysfs code.  The SMBIOS
provides the DMI code, not the other way around.  We've become used to
the DMI code, and we're adding SMBIOS decoding to it but the other parts
of the kernel are doing their own decoding of the SMBIOS to get
additional info.  To me, at least, this means we should have a central
place for it.

Thanks again,

P.
