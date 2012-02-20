Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2BTS3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:29:44 -0500
Received: from imr4.ericy.com ([198.24.6.9]:54619 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2BTS3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:29:43 -0500
Date: Mon, 20 Feb 2012 10:27:02 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5 4/5] hwmon: add MAX197 support
Message-ID: <20120220182702.GA12259@ericsson.com>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1328132138.2261.116.camel@groeck-laptop>
 <20120206151507.73a23eb8@v0nbox>
 <1328561164.2261.258.camel@groeck-laptop>
 <20120210110755.4914b332@v0nbox>
 <20120210161538.GB1060@ericsson.com>
 <20120210131406.28c3a00b@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120210131406.28c3a00b@v0nbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:14:06PM -0500, Vivien Didelot wrote:
> Le Fri, 10 Feb 2012 08:15:38 -0800,
> Guenter Roeck <guenter.roeck@ericsson.com> a écrit :
> 
> > Vivien,
> > 
> > On Fri, Feb 10, 2012 at 11:07:55AM -0500, Vivien Didelot wrote:
> > > Hi,
> > > 
> > > On Mon, 6 Feb 2012 12:46:04 -0800,
> > > Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> > > 
> > > > On Mon, 2012-02-06 at 15:15 -0500, Vivien Didelot wrote:
> > > > [ ... ]
> > > > > 
> > > > > BTW, about the TS-5500 ADC part, is a platform ts5500_adc.c
> > > > > file the better solution, or should the device be declared in
> > > > > the ts5500.c platform code?
> > > > > 
> > > > I would suggest to declare it in the ts5500.c platform code. That
> > > > seems to be the common approach as far as I can see.
> > > > 
> > > > platform_add_devices() works pretty well for this. It saves you
> > > > from having to call platform_device_register() for each device
> > > > separately. Obviously that only works if all devices are declared
> > > > in a single file.
> > > 
> > > As the LED is registered using the leds_class, I think
> > > platform_add_devices() couldn't be used here.
> > > 
> > > Lots of platform codes don't check the returned
> > > value of platform_add_devices(). Should we care about a LED or ADC
> > > registration failure (is the following snippet OK?)?
> > > 
> > >     static int __init ts5500_init(void)
> > >     {
> > >     [...]
> > >         pdev = platform_device_register_simple("ts5500", -1, NULL,
> > > 0); if (IS_ERR(pdev)) {
> > >                 ret = PTR_ERR(pdev);
> > >                 goto release_mem;
> > >         }
> > >         platform_set_drvdata(pdev, ts5500);
> > >     
> > >         ret = sysfs_create_group(&pdev->dev.kobj,
> > >                                  &ts5500_attr_group);
> > >         if (ret)
> > >                 goto release_pdev;
> > >     
> > >         led_classdev_register(&pdev->dev, &ts5500_led_cdev);
> > >         if (ts5500->adc) {
> > >                 ts5500_adc_pdev.dev.parent = &pdev->dev;
> > >                 platform_device_register(&ts5500_adc_pdev);
> > >         }
> > >     
> > I didn't look at other code, but personally I try to be consistent.
> > Why do you check the return value from
> > platform_device_register_simple() above, but not the return code from
> > platform_device_register() ? That does not seem to be very consistent
> > to me.
> 
> I check the platform_device_register_simple() returned value because it
> is the platform itself, while the others are on-board devices. I
> thought that it is not a big deal if their registrations failed but the
> platform registration succeeded. Maybe I'm wrong and I should check
> everything.
> 
Hmm .. seems to make sense. Ok with me. Only question is if you would want
to have it fail silently or issue a log message (possibly debug) to report
the failure.

Guenter
