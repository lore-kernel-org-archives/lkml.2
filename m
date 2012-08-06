Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab2HFLKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:10:21 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:55621 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2HFLKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:10:20 -0400
Message-ID: <501FA608.1030805@firmworks.com>
Date: Mon, 06 Aug 2012 19:10:00 +0800
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: DT GPIO numbering?
References: <20120801152240.GA16388@sig21.net> <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com> <501F296B.4070004@wwwdotorg.org> <CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com> <20120806095805.GA16607@sig21.net>
In-Reply-To: <20120806095805.GA16607@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q76BA1Cw008008 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2012 5:58 PM, Johannes Stezenbach wrote:
> On Mon, Aug 06, 2012 at 08:35:51AM +0200, Linus Walleij wrote:
>> On Mon, Aug 6, 2012 at 4:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>
>>> I can't comment on the sysfs-vs-dev interface location, but I don't
>>> think it addresses Johannes' issue; finding out which GPIO IDs are
>>> provided by which devices.
>>>
>>> Perhaps in each device's sysfs node, there should be some information
>>> re: which GPIO range it provides. Right now, perhaps a text file with
>>> the GPIO base it it.
>>
>> Yes that could work ...
> 
> The method used by the gpio-mxs.c driver (of_alias_get_id)
> would also work.  The question is which method is preferable.
> 
> Ideally I would like to use DT attributes to identify my GPIOs
> in the same way as they appear in the schematics.  E.g.
> one device may have GPIOs called PORT_A.0 to PORT_A.7,
> another one may be EXT.0 to EXT.15.  But a single integer ID
> is good enough since GPIO usage is platform specific anyway.
> However, the mapping must be static and not depend e.g. on
> module load order like now if you use pl061 and some i2c GPIO.
> Software must be able to rely on that e.g. GPIO ID 11
> always refers to EXT.3.

There is precedence for a "slot-names" property that correlates specific
hardware entities with physical labels.  It has been applied to PCI
plug-in slots and to other devices.  See, for example,
http://www.openfirmware.org/1275/proposals/Closed/Accepted/381-it.txt


> 
> 
>>> With the new /dev interface you mention above,
>>> perhaps a symlink to the /dev file, or a file containing the /dev file's
>>> major/minor number. Or, is there such a thing already (other than
>>> debugfs's gpio file).
>>
>> Nothing I know of, but yes the day we come up with something,
>> it needs to be backward-compatible some way.
>>
>> The problem is that there is really no reference userspace
>> like "lsgpio" or so. Maybe the first step could be to create that.
> 
> I don't know much about OpenWrt, but I've seen they have
> something:
> https://dev.openwrt.org/browser/trunk/target/linux/generic/files/drivers/char/gpio_dev.c
> https://dev.openwrt.org/browser/trunk/target/linux/generic/files/include/linux/gpio_dev.h
> https://dev.openwrt.org/browser/trunk/package/gpioctl/src/main.c
> 
> 
> Johannes
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
