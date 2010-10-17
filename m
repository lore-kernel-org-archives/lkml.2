Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0JQBdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:33:53 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4764 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab0JQBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:33:52 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAN/vuUxAaMHG/2dsb2JhbACacYY5caZImzyFSQSEVIV2hQI
X-IronPort-AV: E=Sophos;i="4.57,341,1283731200"; 
   d="scan'208";a="605181962"
From: Roland Dreier <rdreier@cisco.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>,
        Maarten Maathuis <madman2003@gmail.com>
Subject: Re: 2.6.36-rc8 -- drivers/built-in.o: In function `nouveau_acpi_edid': (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
References: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
	<adad3r9hn1x.fsf@cisco.com>
	<AANLkTinsmKABCCmS77MX4UH4NPG2UnQKtoGEcp6hooBJ@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 16 Oct 2010 18:33:32 -0700
In-Reply-To: <AANLkTinsmKABCCmS77MX4UH4NPG2UnQKtoGEcp6hooBJ@mail.gmail.com>
	(Miles Lane's message of "Sat, 16 Oct 2010 21:00:35 -0400")
Message-ID: <aday69xfvrn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I tried with your patch applied and got this:
 > 
 > drivers/built-in.o: In function `load_vbios_acpi':
 > nouveau_bios.c:(.text+0xa9cdf): undefined reference to
 > `nouveau_acpi_rom_supported'

I see, it's not that simple... you'd have to change the CONFIG_ACPI
tests in nouveau_drv.h to be testing CONFIG_ACPI_VIDEO really.

 > When I set CONFIG_DRM_NOUVEAU=m rather than =y, I got this:

If you drop my patch and set CONFIG_DRM_NOUVEAU=m, does it work?
It seems to me that it should.

 - R.
