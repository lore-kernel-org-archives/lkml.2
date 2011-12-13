Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1LMUpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:45:12 -0500
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:53726 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab1LMUpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:45:09 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 13 Dec 2011 14:44:48 -0600
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Topic: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Index: Acy52A6u3y+5zWrsQtahs34ADJRaDQ==
Message-ID: <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
In-Reply-To: <4EE7A31E.7080301@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-10.0.0.1412-6.800.1017-18580.001
x-tm-as-result: No--64.728200-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2011, at 14:10, Rob Herring wrote:
> On 12/13/2011 12:23 PM, Kyle Moffett wrote:
>> 
>> I posted this patch series a few weeks ago and saw no responses, so I
>> tweaked the CC list and am reposting it again for review.
>> 
>> I'm working on support for some custom hardware of ours, and part of
>> the support code is the ability for the software to shutdown the power
>> supply using GPIOs (via an I2C GPIO controller).
>> 
>> I previously had this in my platform code, but it seemed generically
>> useful, so I split it out into a separate module for others to use.
>> 
>> The first two patches are generic of_gpio enhancements, providing some
>> new library functions for requesting lots of GPIOs at once.
>> 
>> The third patch is the actual driver itself.  The driver can be used to
>> instantiate a platform device as a whole-machine-poweroff device as we
>> use it on our hardware.  Alternatively it can instantiate multiple
>> platform devs at specific locations on the device tree which trigger
>> from the platform_driver->shutdown() callback.
>> 
>> For architectures which are still stuck in the dark ages, this driver
>> also supports being instantiated via legacy platform_data.
> 
> Leave them there... :)

Mostly this was out of convenience and imitating the other OF platform
drivers.  I wrote it and ended up with a struct full of probe data being
passed between functions, so I just called it "platform_data" :-D.


>> The OpenFirmware binding documentation is added in the third patch.
>> Since this is my first cut, it's a little rough, so please be gentle.
>> 
>> I'm interested to know what you all think.
> 
> Does the regulator framework gpio-regulator not work for this?

Well, when I initially wrote this code, the regulator framework didn't
exist :-D.

I looked at it a bit when I was generalizing my code, but it seemed
dramatically more complicated than I needed, and I couldn't see any
reasonable way to hook it from the machine_poweroff() code.

There's also the fact that I was looking for a pure-device-tree type
of driver and the regulator framework does not seem to support the
standard OF-platform probe system.

I will admit that there's probably some value in having a more generic
GPIO-power-control (instead of just poweroff), but I don't have the
target use-case to be able to design for it.


> The DT gpio patches look useful on their own.

Yeah, it seemed like a fairly generic extension of the existing API.

Thanks for the comments!

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/


