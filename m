Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2JaEwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:52:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44969 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2JaEwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAFRkauDWf8y24DgoS1wE2ZvG4QtP6sYKbMatHmKjNvR_aFWtuA@mail.gmail.com>
References: <1351487489.18143.3.camel@phoenix> <CAFRkauDWf8y24DgoS1wE2ZvG4QtP6sYKbMatHmKjNvR_aFWtuA@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 30 Oct 2012 21:52:20 -0700
Message-ID: <CAK5ve-JDMNdwgUX_wF-MDs_bE+wVdOtnq0-cVB6oakc3X=4+mg@mail.gmail.com>
Subject: Re: [PATCH RFT] leds: blinkm: Don't init a workqueue per
 brightness_set call
To: Axel Lin <axel.lin@ingics.com>
Cc: Jan-Simon Moeller <jansimon.moeller@gmx.de>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 8:49 PM, Axel Lin <axel.lin@ingics.com> wrote:
>
>
> 2012/10/29 Axel Lin <axel.lin@ingics.com>
>>
>> Calling INIT_WORK in blinkm_led_common_set() means we init a workqueue
>> every time
>> when brightness_set callback is called.
>> Move INIT_WORK to blinkm_probe() so we only need to init the workqueue
>> once.
>>
>> So we only need to init a workqueue per blinkm led rather than init a
>> workqueue
>> per brightness_set call.
>
>
> Ah. the commit log and subject line is wrong.
> We are using the global workqueue.
> What the patch does is to avoid init work rather than workqueue per
> brightness_set call.
> We just need to call INIT_WORK once for the first time that structure is set
> up.
>
> There should be no functional change with this patch.
>
> Regards,
> Axel

Right, I think I did same review when this driver posted on the list firstly.
Probably it is a hardware issue. So let Jan-Simon give us some updates.

If the hardware requires this specific handling, I suggest we add some
comments or documents to clarify that.

Thanks,
-Bryan
