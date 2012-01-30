Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2A3MmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:42:16 -0500
Received: from b.relay.invitel.net ([62.77.203.4]:41852 "EHLO
	b.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2A3MmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:42:15 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 07:42:15 EST
Date: Mon, 30 Jan 2012 13:35:45 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
In-reply-to: <4EDEA3BF.6020507@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Wolfgang Denk <wd@denx.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Vitaly Bordug <vbordug@ru.mvista.com>, linux-watchdog@vger.kernel.org
Reply-to: hs@denx.de
Message-id: <4F268EA1.3090907@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1322991921-21096-1-git-send-email-hs@denx.de>
 <20111204114741.GA5788@pengutronix.de> <4EDCD7B2.5030409@denx.de>
 <20111206215056.GD14154@pengutronix.de>
 <20111206215609.5D1FF1A32820@gemini.denx.de>
 <20111206220620.GF14154@pengutronix.de> <4EDEA3BF.6020507@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob,

Sorry for the late reply ...

Rob Herring wrote:
> On 12/06/2011 04:06 PM, Wolfram Sang wrote:
>>>> bootcount itself is not a device. It is a feature of certain devices. And that
>>>> needs to be implemented; possibly generic enough that it can work for register
>>>> based, i2c based, and so forth, accesses.
>>> If "boot counter" is not a good name for such a device, then what name
>>> would you suggest?
>> None.
>>
>>> Or do you think a counter (which can be implemented in a number of
>>> different ways, depending on hardware specifics) is not a device?
>> Yes.
>>
>>> What would be such a device, then?
>> "maxim,ds1338"
>>
>> Please have a look at the devicetree.org-wiki-page I just mentioned:
>>
>> http://devicetree.org/Device_Tree_Usage
>>
> 
> Perhaps fs/pstore would be a good choice for the user space interface
> (defining a new file bootcount). This can support any arbitrary backing
> device although pretty much only ACPI is implemented.

I tried to use fs/pstore for the bootcount feature, and I can mount
and read the bootcount value from the file, I created. But I could not
write to that file ... I only see the callback from
include/linux/pstore.h

struct pstore_info {
[...]
        int             (*write)(enum pstore_type_id type,
                        enum kmsg_dump_reason reason, u64 *id,
                        unsigned int part, size_t size, struct pstore_info *psi);

called, if I reboot ... do I miss something? Or is it not possible
to write to the files created through fs/pstore?

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
