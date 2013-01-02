Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3ABVKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:10:02 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52869 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752702Ab3ABVKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:10:00 -0500
Date: Wed, 2 Jan 2013 15:09:58 -0600
From: Robin Holt <holt@sgi.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, matt.fleming@intel.com, tglx@linutronix.de,
        mingo@redhat.com
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
Message-ID: <20130102210958.GD3470@sgi.com>
References: <20130102172107.GA26761@gulag1.americas.sgi.com>
 <50E476C2.7060300@zytor.com>
 <50E486E7.1080903@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E486E7.1080903@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 01:13:43PM -0600, Nathan Zimmer wrote:
> On 01/02/2013 12:04 PM, H. Peter Anvin wrote:
> >On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> >>I am getting an early boot problem. It only happens on the larger of the
> >>machines I haven't seen it crop up on machines with more then 512 GB of ram.
> >>It shows in the latest linus kernel too.
> >>
> >>I am (wildly) guessing that what is happening is that the new_memmap that is
> >>being passed to bios is somehow placed incorrectly.
> >>I have come up with a workaround.  By placing it the DMA area the issue goes
> >>away but that doesn't seem like a real fix.
> >>
> >What does your memory map look like?

We reported this a few times (Russ Anderson and I both).  The problem is
at the point in boot where the efi_enter_virtual_mode callback is, there
is no identity mapping for most of memory.  If the allocation happens
to be above the 512GB (or maybe something lower than that) point, the
BIOS is not able to address this via the physical address passed to it.

Russ' solution was to not remap at all.  The interim workaround I have
been using is adding a GFP_DMA flag to the kmalloc.  An earlier post I
made to the list was to pass in the va to the new memmap table.

Robin
