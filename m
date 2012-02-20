Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2BTT4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:56:31 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:58978 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2BTT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:56:30 -0500
Date: Mon, 20 Feb 2012 14:56:11 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5 4/5] hwmon: add MAX197 support
Message-ID: <20120220145611.14b3b115@v0nbox>
In-Reply-To: <20120220182702.GA12259@ericsson.com>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1328132138.2261.116.camel@groeck-laptop>
	<20120206151507.73a23eb8@v0nbox>
	<1328561164.2261.258.camel@groeck-laptop>
	<20120210110755.4914b332@v0nbox>
	<20120210161538.GB1060@ericsson.com>
	<20120210131406.28c3a00b@v0nbox>
	<20120220182702.GA12259@ericsson.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 10:27:02 -0800,
Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> > I check the platform_device_register_simple() returned value
> > because it is the platform itself, while the others are on-board
> > devices. I thought that it is not a big deal if their registrations
> > failed but the platform registration succeeded. Maybe I'm wrong and
> > I should check everything.
> >   
> Hmm .. seems to make sense. Ok with me. Only question is if you would
> want to have it fail silently or issue a log message (possibly debug)
> to report the failure.

Ok, I'll go for something like the following:

    if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
            dev_warn(ts5500_led_cdev.dev, "failed to register the LED\n");
    if (ts5500->adc) {
            ts5500_adc_pdev.dev.parent = &pdev->dev;
            if (platform_device_register(&ts5500_adc_pdev))
                    dev_warn(&ts5500_adc_pdev.dev,
                             "failed to register the A/D converter\n");
    }

Thanks,

-- 
Vivien Didelot
Savoir-faire Linux Inc.
Tel: (514) 276-5468 #149
