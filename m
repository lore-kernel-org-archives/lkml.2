Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2KWKrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:47:13 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35918 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2KWKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121123104140.GP17471@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
	<20121123103400.GO17471@gmail.com>
	<20121123104140.GP17471@gmail.com>
Date: Fri, 23 Nov 2012 16:17:09 +0530
Message-ID: <CAKohpom7Sqj7BeTFdsg04iGvZz1jnqB=UZTLdRNK7X-0ivknsQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 16:11, Lee Jones <lee.jones@linaro.org> wrote:
>> > +++ b/Documentation/devicetree/bindings/gpio/gpio-stmpe.txt
>> > @@ -0,0 +1,18 @@
>> > +STMPE gpio
>> > +----------
>> > +
>> > +Required properties:
>> > + - compatible: "st,stmpe-gpio"
>
> ... but this is wrong.
>
>> > +Example:
>> > +   stmpe_gpio {
>> > +           compatible = "st,stmpe-gpio";
>> > +           st,norequest-mask = <0x20>;     //gpio 5 can't be used
>> > +   };
>
> As is the example.
>
> So will be the the DT - if you've already written it.

Again, I believe these are required by the code you wrote in mfd-core.c

        if (parent->of_node && cell->of_compatible) {
                for_each_child_of_node(parent->of_node, np) {
                        if (of_device_is_compatible(np, cell->of_compatible)) {
                                pdev->dev.of_node = np;
                                break;
                        }
                }
        }

This matches compatible of child node with compatible of cell. And that's
why you have added that in your keypad mappings as well.

--
viresh
