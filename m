Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2DJKEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:04:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45646 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab2DJKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:04:20 -0400
X-Sasl-enc: M9fJ0SaCozsjQqfRDcYc7ObOLGmj/mWT93yII1o5iGHl 1334052258
Message-ID: <4F840599.7060805@ladisch.de>
Date: Tue, 10 Apr 2012 12:04:09 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Stone <alex.parchment@yandex.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: Timing 250 versus 1000
References: <4F815FCE.5040002@yandex.ru> <4F818DBA.3080108@ladisch.de> <4F81CE0A.6080207@yandex.ru>
In-Reply-To: <4F81CE0A.6080207@yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Stone wrote:
> On 04/08/2012 05:08 PM, Clemens Ladisch wrote:
>> Alex Stone wrote:
>>> those of us who write a lot of midi driven work, we're still more or
>>> less required to use some sort of RT kernel to get any degree of
>>> playback timing accuracy.
>>
>> The ALSA sequencer timer stopped using the system timer years ago.
>> And the difference between RT and 'normal' kernels is not the timer
>> frequency.
>
> I'm using jack with seq, so are you saying the ALSA sequencer timer is
> using a higher timer rate than than is set in the kernel,

It's using different timers (RTC or hrtimer), which support higher
precision.

> and there's no need for me to bother with this,

Yes.  If you want to be sure, check that G3 appears in /proc/asound/timers
when you're using the sequencer.


Regards,
Clemens
