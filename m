Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2DUPDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 11:03:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:32984 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2DUPDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 11:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1334967400.3312.4.camel@pasglop>
References: <1334906476.3197.11.camel@pasglop>
	<CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
	<20120420170132.GA32261@core.coreip.homeip.net>
	<1334967400.3312.4.camel@pasglop>
Date: Sat, 21 Apr 2012 09:03:01 -0600
X-Google-Sender-Auth: Wy0jd3o_th9F0he-bBpeqRgszak
Message-ID: <CAMLZHHR-dBipjzNB2cFM_AUcj6=rr4qSX0Pp6jcsvvV+iU1w=Q@mail.gmail.com>
Subject: Re: Multitouch regression in 3.3 on thinkpad X220 clickpad
From: Daniel Drake <dsd@laptop.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 6:16 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>> It looks we lost a condition in synaptics_set_advanced_gesture_mode().
>> It used to be:
>>
>>
>>       if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
>>                       SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
>>               return 0;
>>
>> and now simply is:
>>
>>       if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
>>               return 0;
>>
>> Could you try restoring the condition and see if it fixes the
>> regression?
>
> Yes, that's it. Please shoot the patch below to Linus.

Oops. Thanks Ben and Dmitry, and apologies for causing this bug.

Daniel
