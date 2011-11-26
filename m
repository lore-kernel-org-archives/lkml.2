Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1KZNXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:23:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44897 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1KZNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:23:19 -0500
MIME-Version: 1.0
In-Reply-To: <201111251402.28016.arnd@arndb.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
Date: Sat, 26 Nov 2011 22:23:19 +0900
X-Google-Sender-Auth: 007AqGYFz8wpPTv0QxdVNMjWo5c
Message-ID: <CAH9JG2VTmhTiw=wf66rTZo0fZ4+-MhcAJzfEXzAL4Jybo89v+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Kyungmin Park <kmpark@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 11:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 24 November 2011, MyungJoo Ham wrote:
>> For switch ports, which may have different types of cables
>> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
>> drivers that detect the state changes at the port and device drivers that
>> do something according to the state changes.
>>
>> For example, when MAX8997-MUIC detects a Charger cable insertion, another
>> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
>> or board file) needs to set charger current limit accordingly and when
>> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
>> need to do some operations accordingly.
>>
>> This patchset supports the usage of notifier for passing such information
>> between device drivers.
>>
>> Another issue is that at a single switch port, there might be multiple
>> and heterogeneous cables attached at the same time. Besides, the state
>> (Attached or Detached) of each cable may alter independently.
>>
>> In order to address such issues, Android kernel's "Switch" class seems to
>> be a good basis and we have implemented "Multistate Switch Class" based on
>> it. The "Switch" class code of Android kernel is GPL as well.
>
> How does this relate to the new "pinmux" subsystem that Linus Walleij
> maintains? Would it be useful to integrate your driver into pinmux
> instead of starting a new subsystem?

Hi Arnd,

As you know, the 'pinmux' is based on the GPIO based MUX and changes
the pin state by device driver want.
but multistate switch provides the mechanism which notify the state
change and each device drivers handles it properly.
As described at cover letter, if MHL (Mobile HTML Link) is connected
to the phone, it switch the circuit to use MHL chip and notify the MHL
& HDMI power up. and detached power down the HDMI related chips.

Moreover new 30 pin connector is used, it can support more devices. In
this case we don't need to switch the circuit. Of course some pins are
need to changed  to MUXing purpose. but notify proper information to
each devices.

I think the 'pinmux' is controlled by each device drivers as passive
framework, however multistate switch is active way to know/notify each
devices works properly when external connector is attached to device
(e.g., phone)

BTW does pinmux framework provide the notification mechanism to device?

Thank you,
Kyungmin Park
