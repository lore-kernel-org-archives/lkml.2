Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1GYLho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:37:44 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:24516
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719Ab1GYLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:37:40 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz9371M1be0L1b0bM542M1432Nzz1202hzz8275bh8275dhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Mon, 25 Jul 2011 17:07:34 +0530
Subject: RE: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
Thread-Topic: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
Thread-Index: AcxCEO7fdZgUxmStRMK8qMnJ3wP1AAIq5hrw
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F7404D65@KCINPUNHJCMS01.kpit.com>
References: <1309872103.960.79.camel@L-0532.kpit.com>
	 <1310630232.284.16.camel@L-0532.kpit.com>
 <20110714102928.GL3834@infomag.iguana.be>
In-Reply-To: <20110714102928.GL3834@infomag.iguana.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6PBblZ6029890


> -----Original Message-----
> From: Wim Van Sebroeck [mailto:wim@iguana.be]
> Sent: Thursday, July 14, 2011 3:59 PM
> To: Ashish Jangam
> Cc: linux-kernel@vger.kernel.org; linux-watchdog@vger.kernel.org; Dajun;
> linaro-dev@lists.linaro.org
> Subject: Re: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
> 
> Hi Ashish, Dajun,
> 
> > > This driver adds support for the watchdog functionality provided by the
> Dialog
> > > Semiconductor DA9052 PMIC chip.
> > >
> > > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > > ---
> > If there are no comments then can you ACK this patch?
> 
> I remain with my comment of Wed 26 Jan 2011:
> > The ioctl WDIOC_SETOPTIONS call is not in line with the watchdog API.
> > the supported options are:
> > #define WDIOS_DISABLECARD       0x0001  /* Turn off the watchdog timer */
> > #define WDIOS_ENABLECARD        0x0002  /* Turn on the watchdog timer */
> > #define WDIOS_TEMPPANIC         0x0004  /* Kernel panic on temperature trip
> */
> > Your options are:
> > #define DA9052_STROBING_FILTER_ENABLE   0x0001
> > #define DA9052_STROBING_FILTER_DISABLE  0x0002
> > #define DA9052_SET_STROBING_MODE_MANUAL 0x0004
> > #define DA9052_SET_STROBING_MODE_AUTO   0x0008
> >
> > Please explain what you want to do.
> 
> FYI: this is how the code looks now:
> +       case WDIOC_SETOPTIONS:
> +               if (get_user(new_value, p))
> +                       return -EFAULT;
> +               if (new_value == DA9052_ENABLE || new_value == DA9052_DISABLE)
> +                       da9052_sm_set_strobing_filter(wdt, new_value);
> +               else
> +                       wdt->pwdt->sm_strobe_mode_flag = new_value;
> +               return 0;
> 
> Since the code is still not in line with the watchdog API and since I did not
> get
> an answer yet on what you (or Dajun) want to do, there is definitely NO ACK
> yet.
> If there is a good reasoning behind your needs, we might conclude that this is
> indeed
> worthwhile and extend the API in a proper way. But as it is now, it's not
> correct.
If strobe filter is "Enable" (set/reset thru ioctl) then only a new wdt time window is set 
else if strobe filter is "Disable", new wdt time window is set to a min value or wdt is
disabled depending upon condition.
If the logic is complex then I will simplify it.
> 
> Kind regards,
> Wim.
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
