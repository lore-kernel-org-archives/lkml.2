Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2ISOJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:09:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2ISOJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:09:21 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: RE: [RFC - PATCH] base:pm: prepare driver for common clock framework
Thread-Topic: [RFC - PATCH] base:pm: prepare driver for common clock
 framework
Thread-Index: AQHNkscGQnhzdlyu5EK+tSnspVAZNJeQ+O4AgADArxA=
Date: Wed, 19 Sep 2012 14:09:14 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041D3326@DFLE12.ent.ti.com>
References: <1347661174-15404-1-git-send-email-m-karicheri2@ti.com>
 <201209182334.08229.rjw@sisk.pl>
In-Reply-To: <201209182334.08229.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>> Sent: Tuesday, September 18, 2012 5:34 PM
>> To: Karicheri, Muralidharan
>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Chemparathy, Cyril;
>> mturquette@linaro.org; Magnus Damm; Linux-sh list
>> Subject: Re: [RFC - PATCH] base:pm: prepare driver for common clock framework
>> 
>> On Saturday, September 15, 2012, Murali Karicheri wrote:
>> > As part of my work to migrate davinci SoC code to
>> > use common clk framework, I encountered an issue with this driver
>> > which is calling clk_enable() and clk_disable() without prepare()/
>> > unprepare(). This change is needed to enable common clock migration
>> > for davinci SoCs.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> There are other users of this code than davinci.  For example, sh
>> and ARM/shmobile both use it.  Have you verified that your changes will
>> work for them too?
>> 
Rafael,

Technically do you agree with the changes or do I need to get it reviewed by someone in particular? I have no way of verifying if this works for sh and ARM/shmobile. I have copied this RFC patch to the list showed up by scripts/get_maintainer.pl list. Any idea how I can get this patch reviewed by the sh and ARM/shmobile maintainers and get it tested as well? This is required for DaVinci for sure unless there is an alternate way of doing this. Well, then that is the idea of sending an RFC patch.

-Murali

>> Rafael
>> 
>> 
>> > diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
>> > index eb78e96..9d8fde7 100644
>> > --- a/drivers/base/power/clock_ops.c
>> > +++ b/drivers/base/power/clock_ops.c
>> > @@ -99,7 +99,7 @@ static void __pm_clk_remove(struct pm_clock_entry *ce)
>> >
>> >  	if (ce->status < PCE_STATUS_ERROR) {
>> >  		if (ce->status == PCE_STATUS_ENABLED)
>> > -			clk_disable(ce->clk);
>> > +			clk_disable_unprepare(ce->clk);
>> >
>> >  		if (ce->status >= PCE_STATUS_ACQUIRED)
>> >  			clk_put(ce->clk);
>> > @@ -396,7 +396,7 @@ static void enable_clock(struct device *dev, const char
>> *con_id)
>> >
>> >  	clk = clk_get(dev, con_id);
>> >  	if (!IS_ERR(clk)) {
>> > -		clk_enable(clk);
>> > +		clk_prepare_enable(clk);
>> >  		clk_put(clk);
>> >  		dev_info(dev, "Runtime PM disabled, clock forced on.\n");
>> >  	}
>> > @@ -413,7 +413,7 @@ static void disable_clock(struct device *dev, const char
>> *con_id)
>> >
>> >  	clk = clk_get(dev, con_id);
>> >  	if (!IS_ERR(clk)) {
>> > -		clk_disable(clk);
>> > +		clk_disable_unprepare(clk);
>> >  		clk_put(clk);
>> >  		dev_info(dev, "Runtime PM disabled, clock forced off.\n");
>> >  	}
>> >

