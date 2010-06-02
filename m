Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0FBKLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:11:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51914 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0FBKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=K9xLnsSoqEEhJIgK92j9mxk+vXsTK0Iww8JpAOeoKz/MyTD2JAUF2J3L1iQl4yQ9ZX
         kSHT+F0sKlVD6BIt6otKzhDsM+oDZ1/NhTHPZE8Vs7RlSecQjykax7WnzSbMhSJTd6za
         dzGp2qIVrDWmR/J0OFr0qBLgJPrxCj+2E9ka0=
Subject: How to tell kernel that a region of memory is reserved (in middle
 of ram)?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 13:11:22 +0300
Message-ID: <1275473482.11579.21.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to reserve a region of ram to store there a ramoops buffer.
I need to do so early so kernel doesn't overwrite the existing contents.

How to do it?

I noticed that doing memmap=20M$0x70000000 crashes the system although
it promised to work.
Is that a bug?

I have 2GB system with following memory map:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fcfd000 (usable)
[    0.000000]  BIOS-e820: 000000007fcfd000 - 000000007fd08000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd08000 - 000000007fd52000 (usable)
[    0.000000]  BIOS-e820: 000000007fd52000 - 000000007fd55000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd55000 - 000000007fdbb000 (usable)
[    0.000000]  BIOS-e820: 000000007fdbb000 - 000000007fdbf000 (reserved)
[    0.000000]  BIOS-e820: 000000007fdbf000 - 000000007fe70000 (usable)
[    0.000000]  BIOS-e820: 000000007fe70000 - 000000007febf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007febf000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)


Best regards,
	Maxim Levitsky

