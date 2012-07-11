Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab2GKQ1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:27:51 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:45203 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GKQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:27:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1342024067!8384210!6
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 11 Jul 2012 11:27:46 -0500
Subject: RE: [PATCH 00/83] staging: comedi: rtd520: initial cleanup
Thread-Topic: [PATCH 00/83] staging: comedi: rtd520: initial cleanup
Thread-Index: Ac1fTs7+Pp90VJYXTvukaBuKr2kfFQAMonsw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698FEE715@AUSP01VMBX24.collaborationhost.net>
References: <201207101636.23561.hartleys@visionengravers.com>
 <4FFD536B.8010603@mev.co.uk>
In-Reply-To: <4FFD536B.8010603@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6BGRvhB032446

On Wednesday, July 11, 2012 3:20 AM, Ian Abbott wrote:
> On 2012-07-11 00:36, H Hartley Sweeten wrote:
>> The 'devpriv' macro usage in this driver is holding up other cleanup
>> of the comedi drivers.
>>
>> This patch series removes all the macros used to read/write the
>> hardware registers. All of them are simple wrappers around standard
>> {read,write}[rwl] calls with some of them caching the write value
>> in a shadow variable in the private data.
>>
>> Each of the macros is removed in a separate patch to ease reviewing.
>> They can all be squashed into one patch if desired.
>>
>> After all the macros are gone, the devpriv macro itself can be removed
>> along with the boardinfo macro.
>>
>> The "find pci device" code is also refactored to follow the style of
>> the other comedi pci drivers.
>>
>> The range tables are also cleaned up for aesthetic reasons. The large
>> whitespace causes some pretty nasty line breaks in order to keep the
>> lines < 80 characters.
>
> My main concern with this series of patches is they make it harder to 
> determine what the register accesses actually do, mainly due to the 
> removal of useful comments.  For example:
>
> -	RtdPacerStart(dev);	/* Start PACER */
> +	readl(devpriv->las0 + LAS0_PACER);
>
> And:
>
> -	RtdPacerStop(dev);	/* Stop PACER */
> +	writel(0, devpriv->las0 + LAS0_PACER);
>
> The comments in the original code were quite superfluous, but they would 
> be useful for the replacement code.  In the above cases you could figure 
> it out after looking at the rtd520.h header file where its reasonably 
> clear that reading the LAS0_PACER register starts the pacer and writing 
> the register (presumably with any value) stops the pacer.  But it's less 
> clear in cases such as:
>
> -		RtdAdcConversionSource(dev, 2);	/* BURST triggers ADC */
> +		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);
>
> Since the values for the LAS0_ADC_CONVERSION register are no longer 
> documented anywhere.
> 

Sorry about that. I meant to leave some of the comments as appropriate
but overlooked them during the cleanup.

Some of the magic write values are actually documented in the header with
#define'd values. But, the header is a bit of a mess and it's hard to determine
which bit values go with which register.

The header really needs to be cleaned up and then merged directly into the
source. It's only used by this driver so the defines shouldn't be exposed for
external use. I located the manual for the device and plan on doing that cleanup
eventually.

Regardless, thanks for adding back the comments. I'll look them over and
give you a Reviewed-by shortly.

Thanks,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
