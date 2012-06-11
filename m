Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2FKL3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:29:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50583 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FKL3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:29:01 -0400
Message-ID: <4FD5D679.1070000@linaro.org>
Date: Mon, 11 Jun 2012 12:28:57 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
References: <20120530121547.GJ9947@opensource.wolfsonmicro.com> <4FC63632.4030504@linaro.org> <20120530151119.GN9947@opensource.wolfsonmicro.com> <4FC63B39.6040905@linaro.org> <20120530164152.GP9947@opensource.wolfsonmicro.com> <4FC846CC.20801@linaro.org> <20120601084850.GJ24139@opensource.wolfsonmicro.com> <4FCDDFFC.3000902@linaro.org> <20120605103846.GQ23408@opensource.wolfsonmicro.com> <4FD5C829.2090408@linaro.org> <20120611103606.GG11439@opensource.wolfsonmicro.com>
In-Reply-To: <20120611103606.GG11439@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 11:36, Mark Brown wrote:
> On Mon, Jun 11, 2012 at 11:27:53AM +0100, Lee Jones wrote:
>> On 05/06/12 11:38, Mark Brown wrote:
>
>>> You're missing something - note what I say above about the direction the
>>> mapping is done in, and consider what happens if we've got two of the
>>> same PMIC down in a system.
>
>> I'm still not seeing how this would cause an issue. The only Device
>> Tree nodes which will be parsed are the ones which are specified by
>> a particular driver's compatible string, meaning that any other
>> nodes referencing similar regulator/supply names would be ignored.
>
> Suppose you have two devices of the same type with an array of name
> based regulators, meaning the nodes with constraints have to have a
> particular name in order to be matched to the regulator.  How would a
> consumer reference a node to specify a supply?

some-regulators {
     compatible = "protect_me_from_similarly_named_regulators";

     regulator_node_name_reg: regulator_node_name {
         <blah>
     };
};

[supply_name]-supply = <&regulator_node_name>;

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
