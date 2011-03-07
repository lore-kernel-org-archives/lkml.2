Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1CGUBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:01:17 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:48040
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756098Ab1CGUBP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:01:15 -0500
X-SpamScore: -30
X-BigFish: VS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: Arnaud Patard <arnaud.patard@rtp-net.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Topic: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Index: AQHL3OEO2wru9FbG9kebNQISz1Arp5QiEUJggAB+eQD//7d2MA==
Date: Mon, 7 Mar 2011 20:01:11 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA194690@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
 <56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
 <87oc5puwg3.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
 <87fwqyvrzf.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA1940F8@039-SN1MPN1-004.039d.mgd.msft.net>
 <20110307180700.GQ29521@pengutronix.de>
In-Reply-To: <20110307180700.GQ29521@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.68.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

>-----Original Message-----
>From: s.hauer@pengutronix.de [mailto:s.hauer@pengutronix.de]
>Sent: Monday, March 07, 2011 12:07 PM
>To: Nguyen Dinh-R00091
>Cc: Arnaud Patard; linux@arm.linux.org.uk; linux-kernel@vger.kernel.org; Vaidyanathan Ranjani-RA5478;
>u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
>
>On Mon, Mar 07, 2011 at 04:35:48PM +0000, Nguyen Dinh-R00091 wrote:
>> Hi Arnaud,
>>
>>
>> >-----Original Message-----
>> >From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
>> >bounces@lists.infradead.org] On Behalf Of Arnaud Patard
>> >Sent: Monday, March 07, 2011 10:02 AM
>> >To: Nguyen Dinh-R00091
>> >Cc: linux@arm.linux.org.uk; s.hauer@pengutronix.de; linux-kernel@vger.kernel.org; Vaidyanathan
>> >Ranjani-RA5478; u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; linux-arm-
>> >kernel@lists.infradead.org
>> >Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
>> >
>> >Nguyen Dinh-R00091 <R00091@freescale.com> writes:
>> >
>> >> Hi Arnaud,
>> >
>> >Hi,
>> >>
>> >> Just to verify that you are testing on an MX51-Babbage board? Here's my log:
>> >
>> >I never said I was testing on babbage. The reason is because I'm using a
>> >efika smartbook and not a babbage.
>> >
>> >>
>> >> root@freescale ~$ uname -a
>> >> Linux freescale 2.6.38-rc1+ #93 Fri Mar 4 17:18:15 CST 2011 armv7l GNU/Linux
>> >
>> >2.6.38-rc1+ ? which tree are you using ? The for-next branch of Sascha
>> >Hauer's tree is at least 2.6.38-rc5 so you're trying to merge something
>> >without even testing it on the current tree. Can you please test suspend
>> >with current imx for-next tree (with no other patches than theses 2
>> >patches if possible), in order to make sure that it's still working with it ?
>> >
>>
>> The current imx for-next tree is not booting on my Babbage board. Is
>> it okay for you with your HW. I'll have to debug the booting part
>> first.
>
>Probably because other than kconfig states i.MX51 and i.MX53 cannot be
>compiled in one kernel. the for-next branch boots fine on my babbage.
>

This doesn't seem right. When I do a "make mx51_defconfig", I see that mx51 and mx53 are selected, which is odd but should be okay if you move mx51_defconfig->mx5_defconfig. After doing a "make mx51_defconfig", I have go unselect mx53 in the menuconfig and the image can boot for me on my MX51 HW. I didn't have to do in 2.6.38-rc1? Shouldn't the image generated from mx51_defconfig be bootable on both mx51 and mx53?

I thought we were going the down the path of a single kernel for mx50, mx51, and mx53? Am I missing the correct steps for a single kernel all the mx5 series SoCs?

Internally, we have a single mx5_defconfig for all MX5 SOCs. Is that something we should look to do?

Thanks,
Dinh

>Sascha
>
>
>--
>Pengutronix e.K.                           |                             |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
>Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


