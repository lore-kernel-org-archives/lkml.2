Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0GXAO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 20:14:56 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33546 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab0GXAOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 20:14:54 -0400
X-Sasl-enc: aRrETHpiRbuHSoxI29NZA84xqLRoPiT/NbsyqUipDJkb 1279930493
Date: Fri, 23 Jul 2010 21:14:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100724001449.GA9618@khazad-dum.debian.net>
References: <20100722152220.GA18290@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722152220.GA18290@sgi.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010, Jack Steiner wrote:
> Large SGI UV systems (3072p, 5TB) take a long time to boot. A significant
> part of the boot time is scanning ACPI tables. ACPI tables on UV systems
> are located in RAM memory that is physically attached to node 0.
> 
> User programs (ex., acpidump) read the ACPI tables by mapping them thru
> /dev/mem.  Although mmap tries to map the tables as CACHED, there are
> existing kernel UNCACHED mapping that conflict and the tables end up as
> being mapped UNCACHED.  (See the call to track_pfn_vma_new() in
> remap_pfn_range()).

Well, as it was raised in this thread, ACPI tables are likely to be near RAM
regions used for IPC with the firmware or SMBIOS, and we have no idea of the
kind of crap that could happen if we enable caching on those areas.

OTOH, we *know* of systems that force us to copy the ACPI tables to regular
RAM, otherwise, the utterly broken BIOS corrupts the ACPI tables after the
kernel has loaded.

Couldn't we simply always copy all tables to regular RAM and mark THAT as
cacheable (since there will be no IPC regions in it)?  For the tables that
are only used once, we can free the RAM later.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
