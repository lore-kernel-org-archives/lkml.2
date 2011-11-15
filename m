Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1KOXdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:33:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3923 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab1KOXc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:32:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Nov 2011 15:32:45 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Dong Aisheng <dong.aisheng@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 15 Nov 2011 15:32:34 -0800
Subject: RE: [PATCH] gpio: add flags to export GPIOs when requesting
Thread-Topic: [PATCH] gpio: add flags to export GPIOs when requesting
Thread-Index: Acyj6vxytNr3NoABRO63wggPHfwdawAAykog
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
 <4EC2F035.3060705@solonet.org.ua>
In-Reply-To: <4EC2F035.3060705@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Tuesday, November 15, 2011 4:05 PM:
> Hi Wolfram,
> On 11/16/2011 12:44 AM, Wolfram Sang wrote:
> > Introduce new flags to automatically export GPIOs when using the convenience
> > functions gpio_request_one() or gpio_request_array(). This eases support for
> > custom boards where lots of GPIOs need to be exported for customer
> > applications.
> 
> Adding GPIO maintainer Grant Likely to CC.
> 
> > +#define GPIOF_EXPORT		(1 << 2)
> > +#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
> > +#define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
> > +#define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)
> 
> Maybe, it's better to write like this:
> 
> #define GPIOF_EXPORT			(1 << 2)
> #define GPIOF_EXPORT_DIR_CHANGEABLE	(3 << 2)

Then you won't have a single flag to check if the dir is changeable.

Personally, I'd go for the two single-bit flags, and force boards to OR
them together if they want the GPIO exported and with a changeable
direction; just get rid of the two _DIR_ flags. That said, Wolfram's
patch seems to follow the conventions already in the file.

Dong Aisheng posted patch "gpio: introduce gpio_export_array to ease
export for gpio arrays". Which should we pick; it doesn't seem like we
need both mechanisms.

-- 
nvpublic

