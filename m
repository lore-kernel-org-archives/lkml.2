Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2BXUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:51:58 -0500
Received: from sender1.zohomail.com ([72.5.230.103]:39814 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2BXUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:51:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type; 
  b=aV8rsG3PyR1mZAgkAbOzAzpVqEkqC2M/gQauIvk9JQ/e0eJ+t7Hkk/DD5YjNIVYmOO4zFnQJziC3
    kHHnB1jren+wVGdTGy3IFwMev+vR0DrmxTzATpuF87LKyIafkTaG  
Date: Fri, 24 Feb 2012 21:34:22 +0100
From: Torsten Schenk <torsten.schenk@zoho.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Torsten Schenk <torsten.schenk@zoho.com>, linux-next@vger.kernel.org
Subject: Re: [alsa-devel] linux-next: Tree for Feb 24 (sound/usb/6fire)
Message-Id: <20120224213422.3693943c2dad148b35e26d21@zoho.com>
In-Reply-To: <4F47DBD4.4090803@xenotime.net>
References: <20120224170548.a9a338d64712f06f1b39b7bd@canb.auug.org.au>
	<4F47DBD4.4090803@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ZohoMail: Ss  CHF_MF_NL SS_10 UW UB UW UB  SGR3_15022_212
X-ZohoMail-Sender: 92.193.78.133
X-ZohoMailClient: External
X-Zoho-Virus-Status: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 10:49:56 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 02/23/2012 10:05 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20120223:
> 
> 
> on x86_64:
> 
> ERROR: "_snd_ctl_add_slave" [sound/usb/6fire/snd-usb-6fire.ko]
> undefined! ERROR:
> "snd_ctl_make_virtual_master" [sound/usb/6fire/snd-usb-6fire.ko]
> undefined!
> 
> 
> Full randconfig file is attached.
> 
> CONFIG_SND_VMASTER is not enabled.  Looks like this driver should
> either depend on or select SND_VMASTER.
> 

Sorry, I was unaware that this option needs to be selected.
Patch is attached below that selects SND_VMASTER.

Regards,
Torsten


Select missing SND_VMASTER option in Kconfig.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>

diff -Nur a/sound/usb/Kconfig b/sound/usb/Kconfig
--- a/sound/usb/Kconfig	2012-02-24 21:17:09.543884187 +0100
+++ b/sound/usb/Kconfig	2012-02-24 21:19:16.160372882 +0100
@@ -106,6 +106,7 @@
         select BITREVERSE
         select SND_RAWMIDI
         select SND_PCM
+        select SND_VMASTER
         help
           Say Y here to include support for TerraTec 6fire DMX USB interface.
 

