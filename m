Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0HXHD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:03:59 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:15343 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098Ab0HXHD5 (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Tue, 24 Aug 2010 03:03:57 -0400
Message-Id: <4C73FB7A020000230001F369@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 24 Aug 2010 01:03:54 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <gregkh@suse.de>, <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartF3DEC1CA.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartF3DEC1CA.2__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Matthew, 

於 一，2010-08-23 於 18:51 +0100，Matthew Garrett 提到：
> On Mon, Aug 23, 2010 at 07:53:21PM +0200, Thomas Renninger wrote:
> 
> > Hm, needing a module option to get a system running is not what the user expects.
> > By default, the system should run fine and a module option should be added
> > as a workaround or for debugging only.
> 
> How about we do this instead: add a psb stub driver that does nothing 
> other than call acpi_backlight_register()?
> 

The attached file is a draft stub driver for poulsbo. Like you said, it
will only call acpi_video_register and acpi_video_unregister when
initial and exit.
And I added the Poulsbo pci id in the module alias.

It's works to me, where can we put the driver? in driver/staging ? or
put in driver/gpu/stub ?


Thank's a lot!
Joey Lee


--=__PartF3DEC1CA.2__=
Content-Type: text/plain; name="poulsbo.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="poulsbo.c"

#include <linux/module.h>=0A#include <acpi/video.h>=0A=0Astatic int __init =
poulsbo_init(void)=0A{=0A	printk(KERN_INFO "poulsbo: stub driver =
load.\n");=0A	return acpi_video_register();=0A}=0A=0Astatic void __exit =
poulsbo_cleanup(void)=0A{=0A	acpi_video_unregister();=0A	printk(KERN=
_INFO "poulsbo: stub driver unloaded.\n");=0A}=0A=0Amodule_init(poulsbo_ini=
t);=0Amodule_exit(poulsbo_cleanup);=0A=0AMODULE_AUTHOR("Joey Lee");=0AMODUL=
E_DESCRIPTION("Poulsbo Stub Driver");=0AMODULE_LICENSE("GPL");=0A=0AMODULE_=
ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");=0AMODULE_ALIAS("pci:v0000808=
6d00008109sv*sd*bc*sc*i*");=0A
--=__PartF3DEC1CA.2__=--
