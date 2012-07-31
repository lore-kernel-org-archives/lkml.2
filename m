Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2GaXQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:16:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2GaXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:16:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Cyril Chemparathy <cyril@ti.com>
Subject: Re: [RFC 20/22] ARM: keystone: introducing TI Keystone platform
Date: Tue, 31 Jul 2012 23:16:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, nico@linaro.org, linux@arm.linux.org.uk,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-21-git-send-email-cyril@ti.com>
In-Reply-To: <1343775898-28345-21-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312316.19592.arnd@arndb.de>
X-Provags-ID: V02:K0:OrMv95KzcRCEb/OGSMxeC1TS73MOZHHM/miYBMJaoql
 +j+MSY9O+EGJKuOM/hJ1fJAqfHbvNw3/PiXsyJKbuW8GPtyAr6
 iz6yNLG7Ai5zekg3sNAoJzLPXFjzxuhCEDaKSMm7p5s6KeukGs
 U0GkF7tulWbSa/UJr07McBopmFgcV6ZCZ+aH2UWJ+qzZgOXR5x
 Sj1OF9XvwLozieqfVrl8QtGMeH9Lhcy6priB4g13uYpGn1ScRq
 AGkXFPlxViKR+yMSKymPnkw/pGtx0ZhPg28HTIDEYRJ4M/Tb54
 6V4Ve8zmF5jGmsbc8dpZ6+mKRyP9Ka8Bv2WNGTT2OhP03s0w0+
 GKuUvOx1Br3KXZcdkrPw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Cyril Chemparathy wrote:
> Texas Instruments Keystone family of multicore devices now includes an
> upcoming slew of Cortex A15 based devices.  This patch adds basic definitions
> for a new Keystone sub-architecture in ARM.
> 
> Subsequent patches in this series will extend support to include SMP and take
> advantage of the large physical memory addressing capabilities via LPAE.
> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

And some nitpicking:
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200n8 debug earlyprintk lpj=50000 rdinit=/bin/ash rw root=/dev/ram0 initrd=0x85000000,9M";
> +	};

This command line should not really be here. Most of what you put in it is not
generic to the platform at all.

In order to select the console, use an alias for the serial device.

> +
> +static void __init keystone_map_io(void)
> +{
> +	iotable_init(io_desc, sizeof(io_desc)/sizeof(struct map_desc));
> +}

Use the ARRAY_SIZE macro here.

	Arnd
