Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab1ESPoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:44:39 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:5455 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527Ab1ESPoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:44:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGA61U1Ld/sX/2dsb2JhbAAMhE3bFJEYgSuDZ4EHBJ8i
X-IronPort-AV: E=Sophos;i="4.65,238,1304308800"; 
   d="scan'208";a="114246223"
Message-ID: <4DD53AE5.8020103@teksavvy.com>
Date: Thu, 19 May 2011 11:44:37 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
In-Reply-To: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some more funny business that was new after rc7-git12:

warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI &&
RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has
unmet direct dependencies (MISC_DEVICES)
warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies
(MISC_FILESYSTEMS)

The exact same .config didn't do that with rc7-git12,
but does do it with 2.6.39 final.

Odd thing is, if I select both MISC_DEVICES and MISC_FILESYSTEMS,
but do NOT select anything from under either of those,
the warnings go away.

Which likely means the warnings are totally bogus.

Cheers
