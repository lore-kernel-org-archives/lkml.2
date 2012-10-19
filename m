Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2JSJaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:30:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19963 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2JSJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:30:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Oct 2012 02:30:02 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Tony Prisk <linux@prisktech.co.nz>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v7 2/3] pwm_backlight: use power sequences
Date: Fri, 19 Oct 2012 18:31:53 +0900
Message-ID: <2048338.SjS64CMeN7@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.2-1-ARCH; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1350638436.3339.2.camel@gitbox>
References: <1350637589-7405-1-git-send-email-acourbot@nvidia.com> <1350637589-7405-3-git-send-email-acourbot@nvidia.com> <1350638436.3339.2.camel@gitbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2012 17:20:36 Tony Prisk wrote:
> On Fri, 2012-10-19 at 18:06 +0900, Alexandre Courbot wrote:
> > +static void pwm_backlight_on(struct backlight_device *bl)
> > +{
> > +     struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> > +     int ret;
> > +
> > +     if (pb->enabled)
> > +             return;
> > +
> > +     if (pb->power_on_seq) {
> > +             ret = power_seq_run(pb->power_on_seq);
> > +             if (ret < 0) {
> > +                     dev_err(&bl->dev, "cannot run power on
> > sequence\n");
> > +                     return;
> > +             }
> > +     } else {
> > +             /* legacy framework */
> > +             pwm_config(pb->pwm, 0, pb->period);
> > +             pwm_disable(pb->pwm);
> 
> Is this right? pwm_disable() in the backlight_on function?

Now everybody will notice that I never really tested the legacy interface. >_<

Thanks, this was totally wrong indeed.

Alex.

