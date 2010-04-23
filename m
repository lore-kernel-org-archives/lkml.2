Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0DWTwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:52:05 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:42033 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0DWTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:52:01 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BD1FA5A.6060406@tremplin-utc.net>
Date: Fri, 23 Apr 2010 21:51:54 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Make WMI be selected automatically when needed
References: <4BC8FF9D.7050500@tremplin-utc.net> <20100416173127.6b968fd4.randy.dunlap@oracle.com> <4BC907B5.2050104@tremplin-utc.net> <20100423192059.GA32705@srcf.ucam.org>
In-Reply-To: <20100423192059.GA32705@srcf.ucam.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 23-04-10 21:20, Matthew Garrett schreef:
> On Sat, Apr 17, 2010 at 02:58:29AM +0200, Éric Piel wrote:
> 
>>  config LEDS_DELL_NETBOOKS
>>  	tristate "External LED on Dell Business Netbooks"
>> -	depends on X86 && ACPI_WMI
>> +	depends on X86
>> +	depends on ACPI
>> +	select ACPI_WMI
> 
> I dislike this. The originally stated dependencies are correct and more 
> accurately represent what the code requires, and changing that for the 
> sake of making it easier for people to find the driver sounds like it's 
> trying to cover up shortcomings in our configuration system more than 
> anything else.
> 
Currently there are 2 modules which select ACPI_WMI and 4 which depend
on it. There are 7 modules which select BACKLIGHT_CLASS_DEVICE and as
many which depend on it. Making usage of the select functionality all
the time would avoid these inconsistencies.

Eric
