Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3AANTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 08:19:55 -0500
Received: from plane.gmane.org ([80.91.229.3]:48907 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab3AANTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 08:19:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Elisey Shemyakin <elisey@shemyakin.me>
Subject: Re: [PATCH] x86: Aspire One Happy2 reboots only with the kbd method
Date: Tue, 1 Jan 2013 13:16:31 +0000 (UTC)
Message-ID: <loom.20130101T120312-589@post.gmane.org>
References: <20120621133203.GA26316@zverina> <20120621142938.GZ32472@redhat.com> <4FE33278.20807@zytor.com> <20120621222228.GA27593@zverina> <4FE39FC5.8060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 62.176.18.211 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa <at> zytor.com> writes:

> 
> On 06/21/2012 03:22 PM, Uros Vampl wrote:
> > 
> > I advised the Arch user to join this discussion and provide the 
> > requested info. I immediately went for kbd as the solution because 
> > that's exactly what I need for my own Aspire One - that AOA110 quirk 
> > that's visible in the context of this patch. I figured it's a pattern, 
> > Aspire One machines quirky in the same way.
> > 
> 
> Probably, but we'd like to figure out what is going on.
> 
> 	-hpa
>
 
Hi. I got here from this forum https://bbs.archlinux.org/viewtopic.php?id=143716
 with the same issue on the same device.

Here is FACP table from acpidump output:

FACP @ 0x7f5fd000
  0000: 46 41 43 50 f4 00 00 00 04 4c 41 43 52 53 59 53  FACP.....LACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 00 00 04 00 00 30 58 7f 00 10 5f 7f 00 02 09 00  .....0X..._.....
  0030: b2 00 00 00 a0 a1 00 80 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 20 04 00 00 08 04 00 00  ........ .......
  0050: 28 04 00 00 00 00 00 00 04 02 01 04 08 00 00 85  (...............
  0060: 65 00 e9 03 00 00 00 00 01 03 0d 00 00 03 00 00  e...............
  0070: a5 84 00 00 01 08 00 01 b2 00 00 00 00 00 00 00  ................
  0080: fb 00 00 00 00 30 58 7f 00 00 00 00 00 10 5f 7f  .....0X......._.
  0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00f0: 00 00 00 00

I have tried to reboot with different kernel parameters.
Worked: kbd, efi, bios
Not worked: acpi, triple, pci

So, this patch works for me:

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -447,6 +447,14 @@ 
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
+	{	/* Handle reboot issue on the Acer Aspire One Happy2. */
+		.callback = set_kbd_reboot,
+		.ident = "Acer Aspire One Happy2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOHAPPY2"),
+		},
+	},
 	{ }
 };


