Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2KWM2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:28:42 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:35349
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab2KWM2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:28:41 -0500
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI9371I936eI542M1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631hbe9i1155h)
Subject: RE: [Patch v3 3/7] rtc: DA9055 RTC driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "p_gortmaker@yahoo.com" <p_gortmaker@yahoo.com>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E1702F4A9@BGMAIL02.nvidia.com>
References: <1349952025.9228.3.camel@dhruva>
	 <1350986593.23353.3.camel@dhruva> <1353665463.1760.3000.camel@dhruva>
	 <D958900912E20642BCBC71664EFECE3E6E1702F4A9@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Nov 2012 17:57:37 +0530
Message-ID: <1353673657.11305.7.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 16:39 +0530, Venu Byravarasu wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Ashish Jangam
> > Sent: Friday, November 23, 2012 3:41 PM
> > To: akpm@linux-foundation.org
> > Cc: linux-kernel@vger.kernel.org; sameo@linux.intel.com;
> > p_gortmaker@yahoo.com; dchen@diasemi.com; rtc-
> > linux@googlegroups.com; Alessandro Zummo
> > Subject: Re: [Patch v3 3/7] rtc: DA9055 RTC driver
> > 
> > Any comments on this patch.
> > On Tue, 2012-10-23 at 15:33 +0530, Ashish Jangam wrote:
> > > Does this patch looks good?
> > > On Thu, 2012-10-11 at 16:10 +0530, Ashish Jangam wrote:
> > > > This is the RTC patch for the DA9055 PMIC. This patch has got
> > dependency on
> > > > the DA9055 MFD core.
> > > >
> > > > This patch is functionally tested on Samsung SMDKV6410.
> > > >
> > > > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > > > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > > > ---
> > > > changes since version v3:
> > > > - use of module_platform_driver macro
> > > > - add the regmap virtual irq map API.
> > > > changes since version v2:
> > > > - Use of devm_request_threaded_irq API
> > > > ---
> > > >  drivers/rtc/Kconfig      |   10 +
> > > >  drivers/rtc/Makefile     |    1 +
> > > >  drivers/rtc/rtc-da9055.c |  413
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 424 insertions(+), 0 deletions(-)
> > > >  mode change 100644 => 100755 drivers/rtc/Kconfig
> > > >  create mode 100644 drivers/rtc/rtc-da9055.c
> > > >
> 
> > > > +static int da9055_set_alarm(struct da9055 *da9055, struct rtc_time
> > *rtc_tm)
> > > > +{
> > > > +	int ret;
> > > > +	uint8_t v[2];
> > > > +
> > > > +	rtc_tm->tm_year -= 100;
> > > > +	rtc_tm->tm_mon += 1;
> > > > +
> > > > +	ret = da9055_reg_update(da9055, DA9055_REG_ALARM_MI,
> > > > +				DA9055_RTC_ALM_MIN, rtc_tm->tm_min);
> > > > +	if (ret != 0) {
> > > > +		dev_err(da9055->dev, "Failed to write ALRM MIN: %d\n",
> > ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	v[0] = rtc_tm->tm_hour;
> > > > +	v[1] = rtc_tm->tm_mday;
> > > > +
> > > > +	ret = da9055_group_write(da9055, DA9055_REG_ALARM_H, 2, v);
> 
> Why don't you write all registers at once using single multi byte
> write command as you already used in da9055_rtc_set_time() ?
Unlike TIME/Date registers some of the ALARM register bits has got few
other bits which should not get modified during the setting of ALARM
therefore reg_update was used for those ALARM register.   


