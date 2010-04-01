Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0DAGSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:18:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0DAGSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:18:51 -0400
Date: Thu, 1 Apr 2010 08:18:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: linux-next: build failure after merge of the final tree (hid
 tree related)
In-Reply-To: <20100401170639.9f2fe605.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1004010817420.8345@pobox.suse.cz>
References: <20100401170639.9f2fe605.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/hid/hid-picolcd.c: In function 'picolcd_debug_reset_write':
> drivers/hid/hid-picolcd.c:1343: error: implicit declaration of function 'copy_from_user'
> drivers/hid/hid-picolcd.c: In function 'picolcd_debug_eeprom_read':
> drivers/hid/hid-picolcd.c:1407: error: implicit declaration of function 'copy_to_user'
> 
> Caused by commit 9bbf2b98ba11d00bd73e3254e15cfe17ccaff6ba ("HID: add
> experimental access to PicoLCD device's EEPROM and FLASH").  Using copy_
> {to,from}_user requires the include of linux/uaccess.h.
> 
> I have reverted that commit for today.

Hmm, on which arch did this bomb out? I wonder why it is building fine for 
me.

Anyway, I have added the include, as it is obviously correct(tm), thanks 
for reporting it.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
