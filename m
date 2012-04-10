Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2DJHm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 03:42:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2DJHm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 03:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <4F7BC36E.4070000@wwwdotorg.org>
References: <20120404124437.ff05ebcc4db98109d5fcee22@canb.auug.org.au>
	<4F7BC36E.4070000@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:42:26 +0200
Message-ID: <CACRpkdY57hQOvpqxaaYyJoH0ewfOAj9RqzWtC=aOWQyNMoG6fg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:43 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/03/2012 08:44 PM, Stephen Rothwell wrote:
>> Hi Linus,
>>
>> After merging the pinctrl tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> drivers/pinctrl/devicetree.c: In function 'dt_free_map':
>> drivers/pinctrl/devicetree.c:44:42: error: dereferencing pointer to
>> incomplete type drivers/pinctrl/devicetree.c:45:6: error:
>> dereferencing pointer to incomplete type
>> drivers/pinctrl/devicetree.c: In function 'dt_to_map_one_config':
>> drivers/pinctrl/devicetree.c:140:21: error: dereferencing pointer
>> to incomplete type drivers/pinctrl/devicetree.c:141:10: error:
>> dereferencing pointer to incomplete type
>> drivers/pinctrl/devicetree.c:146:11: error: dereferencing pointer
>> to incomplete type
>
> This doesn't repro for me with tegra_defconfig, which has both
> CONFIG_PINCTRL and CONFIG_OF enabled.
>
> I believe this happens because of the following in
> drivers/pinctrl/Makefile:
>
> obj-$(CONFIG_OF)                += devicetree.o
>
> On ppc64, CONFIG_OF is probably true, yet the rest of PINCTRL isn't
> enabled, hence the headers that are included probably don't declare
> all the types needed to compile that file.
>
> In fact, the file shouldn't be compiled, since it's not needed if
> !CONFIG_PINCTRL. So perhaps the Makefile should be more like:
>
> ifeq ($(CONFIG_OF),y)
> obj-$(CONFIG_PINCTRL)           += devicetree.o
> endif

Easiest fixed with a new Kconfig like CONFIG_PINCTRL_OF that
depend on both right?

I'll cook a patch.

Yours,
Linus Walleij
