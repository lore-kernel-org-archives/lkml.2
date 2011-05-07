Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1EGTGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:06:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1EGTGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=meFwHa8v7FIWjvPcP070qAna5KZi28uAXZG0bKbzPHhT0w4+C+FcMGhp8ojyDZ9Ku0
         1CQRH46t2FoN1ui1v0jo+tY9QqF1fIVRxbtRGIDyUx4JUTwmCpDtbCc+f90JFDiwFDkb
         5ZDUfaxWBCLMaXNhGP8Apq+Kktnb++j9I/77A=
MIME-Version: 1.0
In-Reply-To: <20110504092219.GW2092@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
	<BANLkTimKU-=GXzrn8=MQn-GAmKHOvKmuNQ@mail.gmail.com>
	<20110504092219.GW2092@atomide.com>
Date: Sat, 7 May 2011 22:06:47 +0300
Message-ID: <BANLkTin9-aKZjEGdBeZqDwHwADXCYERErg@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Colin Cross <ccross@google.com>, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 12:22 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Colin Cross <ccross@google.com> [110502 14:26]:
>> On Mon, May 2, 2011 at 1:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>> * Drive strength is also controlled through groups of pins, but
>> different groups than pinmux.  Most of the drive strength groups are
>> collections of pad mux groups, but there are a few pins that are in
>> the same pad mux group but a different drive strength group.
>> * Setting a pin as a GPIO overrides its group's mux setting, except
>> for the group's tristate.  You must untristate the entire group to use
>> a single pin as a GPIO.
>> * Each group has a "safe mode", but which mux id to select to enter
>> the safe mode is completely random.
>
> Just posted something in this thread regarding using standard data and
> standard read and write functions, then allow setting platform specific
> custom flags as needed. Care to see if that works for you too?

Tegra does not allow pin muxing on the pin by pin basis. And,
registers that define mux config differ from those that define flags
(pull, driver strength, safe mode etc).

>> In the end, we determined that there was no way to sanely handle
>> setting up Tegra's pinmux programatically, and instead required each
>> board to pass in a table of pinmux settings.
>
> Eventually we should get the package specific table of available pins
> and the board specific settings in devicetree data. And then it's
> easy to set the pins as desired while being able to debug it.
>
> Regards,
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
    Sincerely Yours,
        Mike.
