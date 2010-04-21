Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0DUXEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:04:11 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33104 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0DUXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:04:09 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
Date: Wed, 21 Apr 2010 17:04:04 -0600
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
References: <20100409223532.GC11130@hexapodia.org> <201004211059.17264.bjorn.helgaas@hp.com> <4BCF7D38.8070206@zytor.com>
In-Reply-To: <4BCF7D38.8070206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004211704.05541.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010 04:33:28 pm H. Peter Anvin wrote:
> Do you have opinions on patches 1-2 of the series?
> 
> I'm getting concerned about how the size of the patchset has grown, and
> we're past -rc5 already... but it is a regression so we can't just defer
> it to .35.

Part 1: the essential part of this seems to be the trim_bios_range()
change, and that part is not too big.  In v4, Yinghai also removed
probe_roms_32.c.  That sounds like the right thing to do, but I'd
rather have that in separate patch so it doesn't obfuscate the other
change, and I don't know whether it *has* to be done for .34; maybe
it could be deferred.

Part 2: IMHO, we're putting way too much crap in kernel/resource.c.
A name like "reserve_region_with_split_check_child()" is a pretty
good clue that we've lost our way somewhere.  But that's mostly a
cosmetic thing, and the end result does seem to be something that
fixes the current regression.

So I guess that in spite of my issues with the implementation, I'm
still OK with the concept.

Bjorn
