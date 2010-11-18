Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab0KRXsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:48:40 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4870 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab0KRXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:48:39 -0500
Message-ID: <4CE5BB56.4040605@caviumnetworks.com>
Date: Thu, 18 Nov 2010 15:48:38 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] of/phylib: Use device tree properties to initialize
 Marvell PHYs.
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com> <1290038071-13296-2-git-send-email-ddaney@caviumnetworks.com> <20101118204036.GA16908@angua.secretlab.ca>
In-Reply-To: <20101118204036.GA16908@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 23:49:29.0422 (UTC) FILETIME=[3D96EEE0:01CB877B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:40 PM, Grant Likely wrote:
> On Wed, Nov 17, 2010 at 03:54:30PM -0800, David Daney wrote:
>> Some aspects of PHY initialization are board dependent, things like
>> indicator LED connections and some clocking modes cannot be determined
>> by probing.  The dev_flags element of struct phy_device can be used to
>> control these things if an appropriate value can be passed from the
>> Ethernet driver.  We run into problems however if the PHY connections
>> are specified by the device tree.  There is no way for the Ethernet
>> driver to know what flags it should pass.
>>
>> If we are using the device tree, the struct phy_device will be
>> populated with the device tree node corresponding to the PHY, and we
>> can extract extra configuration information from there.
>>
>> The next question is what should the format of that information be?
>> It is highly device specific, and the device tree representation
>> should not be tied to any arbitrary kernel defined constants.  A
>> straight forward representation is just to specify the exact bits that
>> should be set using the "marvell,reg-init" property:
>>
>>        phy5: ethernet-phy@5 {
>> 	reg =<5>;
>> 	device_type = "ethernet-phy";
>
> Some notes:
> - device_type is only relevant for real openfirmware platforms.  It
>    should not appear in dts files.

Documentation/powerpc/dts-bindings/phy.txt says device_type should be 
here.  I can remove it from my patch comment, but should it also be 
removed from the phy.txt file?

> - This example phy node needs a compatible property

Ok, what would you suggest?  Something like:

      compatible = "marvell,88e1145";

I can certainly do that, but I would note that the kernel probes these 
things and would completely ignore the compatible property.

> - This new binding needs to be documented.  You can use devicetree.org.
>

Agreed, I was planning to do that once the patch was approved.

Where would that go?  Vendor:Marvell, or Type:PHY/compatible=marvell,* 
... or somewhere else?

>> 	marvell,reg-init =
>> 		<0x00030010 0x5777>, /* Reg 3,16<- 0x5777 */
>> 		<0x00030011 0x00aa>, /* Reg 3,17<- 0x00aa */
>> 		<0x00030012 0x4105>, /* Reg 3,18<- 0x4105 */
>> 		<0x00030013 0x0060>; /* Reg 3,19<- 0x0060 */
>> 		<0x00020015 0x00300000>; /* clear bits 4..5 of Reg 2,21 */
>>        };
>>


Thanks,
David Daney
