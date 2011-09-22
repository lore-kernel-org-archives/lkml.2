Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1IVBlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:41:35 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35237 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750971Ab1IVBlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:41:35 -0400
Message-ID: <4E7A9276.803@marvell.com>
Date: Thu, 22 Sep 2011 09:42:14 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Questions for dummy codec driver
References: <1316502540.4269.1.camel@phoenix> <4E794A96.9040206@marvell.com> <20110921125607.GC25620@sirena.org.uk>
In-Reply-To: <20110921125607.GC25620@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2011 01:40:00.0865 (UTC) FILETIME=[8B0E1510:01CC78C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/21/2011 08:56 PM, Mark Brown wrote:
> On Wed, Sep 21, 2011 at 10:23:18AM +0800, Leo Yan wrote:
>
>> I have a question for the dummy codec.
>
> Don't start new threads by randomly replying to unrelated mails.
>

Sorry for that :-), the alsa-devel is the unrelated mailing list, right?
if so, i will note for that later.

>> As you know, sometimes maybe we only need set the timing from the
>> processor, and codec just only need tx/rx data; So there do not need
>> the codec driver.
>
> Even a dumb CODEC will have some constraints on things like the sample
> rates it can support which need to be conveyed to the framework and
> ideally the audio routing out of the CODEC should be visible for
> integration with any external output drivers or similar.
>

Get it.

On our platform, there have some devices (like hdmi/bt) do not need 
config from the CODEC driver, they have their own s/w stack and 
interface to configure; for the audio driver, just need to set the 
I2S/PCM timing for them. So if there have a common dummy codec driver, 
then it can meet our requirement well. Otherwise, there will have some 
duplicate codes for these dummy codecs.

>> After browser the code, there have NO such a dummy codec driver; and
>> for soc-core, there have not such flags to support this situation.
>> Only what i get is sound/soc/codecs/spdif_transciever.c, but it's
>> specific for TI's DaVinci platform.
>
> Not at all, what makes you believe that it is platform specific?
