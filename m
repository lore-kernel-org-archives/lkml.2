Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2EIONw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:13:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415Ab2EIONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:13:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Date: Wed, 9 May 2012 14:13:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "olof@lixom.net" <olof@lixom.net>
References: <20120509075407.5991.60556.sendpatchset@w520> <201205091345.34404.arnd@arndb.de> <alpine.LFD.2.02.1205090955520.21030@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1205090955520.21030@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091413.37664.arnd@arndb.de>
X-Provags-ID: V02:K0:Qgm5OxnfFaOYBO45FLOofOfxY4yF2fTSObPoIU34HjX
 FQOLgm0O7dQKNoTUFgskH61w6EYzlr9Oe4enY4llcRppiuIidA
 4cMD6knXdmF3cMRt8yCJQJDAS+a8endUUO3JO3g9A+P5UEiT+o
 8o9o956eYxTUzCelJeKLBr2Nh3nvkaT1TW6p5EtdWTdNZZAplx
 yTJlfH5jtBAh80k4x7BDgnhBnCKfHs9xGCq4rwrPhqV8Pn3VS+
 bch6lgVmIoWWhR7q50LPuAKlNffH2brJRIXw0UXf1MSvhPA81h
 1eIlDVEq5+PhImSUG5l1yJkdOnA7V+LfiSdvL+tdDLsumLs1AI
 Zg6SEaTV/0BXBq8HBnNc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Nicolas Pitre wrote:
> On Wed, 9 May 2012, Arnd Bergmann wrote:
> 
> > FWIW, I would actually prefer merging the 'struct arm_soc_desc', 'struct
> > arm_soc_smp_init_ops' and 'struct arm_soc_smp_ops' structures into a
> > single 'struct smp_ops' for simplicity.
> 
> You can't easily validate correct usage of __init marked code from the 
> rest if everything is pulled in the same struct.  This is why I asked 
> they be split.

Ah, I see. However, in version 6 of the patch set, each platform
was marking both structures as __initdata, which seems to make
your argument pointless because we don't actually validate the
sections.

	Arnd
