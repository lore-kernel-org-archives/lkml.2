Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1BFKab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:30:31 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:39343 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab1BFKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:30:28 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 69F059C188
Message-Id: <E1Pm1so-00025V-Am@be1.7eggert.dyndns.org>
From: Bodo Eggert 
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        castet.matthieu@free.fr,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Reply-To: 7eggert@nurfuerspam.de
Date: Sun, 06 Feb 2011 11:30:17 +0100
References: <ghb2G-3tw-7@gated-at.bofh.it> <ghjtg-WV-5@gated-at.bofh.it> <ghosV-TN-9@gated-at.bofh.it> <ghEo1-2IF-1@gated-at.bofh.it> <gifGW-7eL-13@gated-at.bofh.it>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> In static_protections() we have:
> 
>>         /*
>>          * The BIOS area between 640k and 1Mb needs to be executable for
>>          * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
>>          */

I don't think the CGA/MDA/VGA graphics memory areas should be executable,
and I doubt execute access to these areas is required - is it?

0xA000:0000 might be a BIOS area, if it is, you don't have a VGA and the
ROM will be exactly 64K. 0xB800 and 0xB000 SHOULD NOT be a ROM, nobody dared
to use it (I don't remember exactly where ROMs are searched).
-- 
Funny quotes:
34. If FedEx and UPS were to merge, would they call it Fed UP?

Friß, Spammer: igc@vhFgi.7eggert.dyndns.org fdnJu@jQOez.7eggert.dyndns.org

