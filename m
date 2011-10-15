Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1JOOi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:38:27 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:36362 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1JOOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:38:25 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Oct 2011 10:38:25 EDT
Date: Sun, 16 Oct 2011 01:29:56 +1100
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20111016012956.2af0c3d0@lenov0n>
In-Reply-To: <20111014061427.GD19874@elte.hu>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20111012153541.GB26529@elte.hu>
	<20111014061427.GD19874@elte.hu>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011 08:14:27 +0200,
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > 
> > > From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> > > 
> > > Signed-off-by: Vivien Didelot
> > > <vivien.didelot@savoirfairelinux.com>
> > 
> > Same question as for the other patch, was this intended to be:
> > 
> >   From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> >  
> >   Signed-off-by: Jerome Oufella
> > <jerome.oufella@savoirfairelinux.com> Signed-off-by: Vivien Didelot
> > <vivien.didelot@savoirfairelinux.com>
> > 
> > ?
> 
> Ping? These patches cannot be advanced without a proper SOB sequence.

Sorry for the late reply.

You're right, this should be:
Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

> 
> Also, with the attached config i get this build failure:
> 
>  arch/x86/built-in.o: In function `ts5500_adc_probe':
>  ts5500_adc.c:(.devinit.text+0x1e1): undefined reference to
> `hwmon_device_register' make: *** [.tmp_vmlinux1] Error 1
> 
> Which kind of build failure is typically some sort of 
> modular/built-in corner case combination:
> 
>  CONFIG_HWMON=m
>  CONFIG_HWMON_VID=m
>  # CONFIG_HWMON_DEBUG_CHIP is not set
>  CONFIG_THERMAL_HWMON=y
>  CONFIG_TS5500=y
>  # CONFIG_TS5500_GPIO is not set
>  CONFIG_TS5500_LED=y
>  CONFIG_TS5500_ADC=y
>  CONFIG_LEDS_GPIO=m
>  CONFIG_LEDS_TRIGGER_GPIO=m
> 
> And is generally fixed by cleaner/better Kconfig dependencies.
> 
> Thanks,
> 
> 	Ingo

Thanks for the comment, there's obviously a dependence issue here. This
will be fixed soon.

Thanks,

	Vivien
