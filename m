Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1F2LrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:47:05 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9707 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1F2LrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:47:03 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eK1102K1432N98dKzz1202hzzz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: Re: [PATCH 6/11] HWMON: DA9052 hwmon driver v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <1309282554.2612.7.camel@groeck-laptop>
References: <1309271069.376.236.camel@L-0532.kpit.com>
	 <1309282554.2612.7.camel@groeck-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 17:14:08 +0530
Message-ID: <1309347848.4210.14.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 23:05 +0530, Guenter Roeck wrote:
> On Tue, 2011-06-28 at 10:24 -0400, ashish jangam wrote:
> > +static ssize_t da9052_read_vddout(struct device *dev,
> > +                                  struct device_attribute *devattr, char *buf)
> > +{
> > +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> > +       int ret, vdd = -1;
> > +
> > +       mutex_lock(&hwmon->hwmon_lock);
> > +
> > +       ret = da9052_enable_vddout_channel(hwmon->da9052);
> > +       if (ret < 0)
> > +               goto hwmon_err;
> > +
> > +       ret = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
> > +       if (ret < 0)
> > +               pr_err("failed to read VDD_RES_REG\n");
> > +       else
> > +               vdd = ret;
> > +
> > +       ret = da9052_disable_vddout_channel(hwmon->da9052);
> > +       if (ret < 0)
> > +               goto hwmon_err;
> > +
> > +       if (vdd >= 0) {
> > +               mutex_unlock(&hwmon->hwmon_lock);
> > +               return sprintf(buf, "%d\n", vdd);
> > +       }
> > +
> > +hwmon_err:
> > +       mutex_unlock(&hwmon->hwmon_lock);
> > +       return ret;
> > +}
> 
> This function still produces a bad result if the call to
> da9052_reg_read() fails and the call to da9052_disable_vddout_channel()
> doesn't. 
Thanks much for comments and patience. When vddout channel is enabled
and then read from this channel fails then, in this case should vddout
channel get disabled? Is this correct understanding.
> 
> I would suggest to replace pr_err() with "goto hwmon_err". If you do
> that, you don't need to initialize vdd, you don't need the else case for
> its assignment, and you don't need "if (vdd >= 0)" either.
Will take care of this. Thanks...Ashish
> 
> Guenter
> 
> 
> 


