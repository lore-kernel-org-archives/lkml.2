Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab2EZLxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:53:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43735 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2EZLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:53:14 -0400
Message-ID: <4FC0C422.8080605@tremplin-utc.net>
Date: Sat, 26 May 2012 13:53:06 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Darren Hart <dvhart@linux.intel.com>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
References: <4FBF0AC1.6030406@linux.intel.com> <20120525051051.GA3135@kroah.com>
In-Reply-To: <20120525051051.GA3135@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-05-12 07:10, Greg Kroah-Hartman wrote:
> On Thu, May 24, 2012 at 09:29:53PM -0700, Darren Hart wrote:
>> I'm working to enable the LIS331DLH accelerometer on the Fish River
>> Island II embedded atom development kit.
>>
>> I am more interested in enabling people to do bizarre and interesting
>> things with the device, so I'm leaning toward continuing with my IIO
>> implementation.
>
> Make it an IIO driver and then we can delete the misc driver, which
> shouldn't have snuck in there in the first place :)
>

To be more fair to the misc driver, I wouldn't say it snucked in there, 
but more "it ended up there as the least worse place" ;-) Actually, the 
main problem is that there seemed to be no maintainer interested in 
taking care of accelerometer devices. Now that the IIO subsystem is out 
of staging, it might be a right place. That said, I don't know much 
about the user interface to IIO. I know that I liked the idea of having 
an joystick device created for an accelerometer because that allows to 
get many programs to access the device almost without any modifications.

I'd happy to help merge the lis3lv02d driver into IIO. IMHO, the main 
steps are:
  * make sure all the various buses are supported (e.g., I²C, SPI, and 
also "ACPI-HP")
  * ensure the various versions of the accelerometer are supported 
(there are 3 supported currently)
  * check that the driver is automatically loaded on HP laptops (via 
ACPI entry)
  * for each of the current interfaces decide if they should be ported 
or dropped (/dev/js*, /dev/freefall, sysfs...)

What do you think Jonathan?

Cheers,
Éric
