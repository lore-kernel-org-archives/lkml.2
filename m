Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3ACPvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:51:06 -0500
Received: from mga10.intel.com ([192.55.52.92]:10997 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753412Ab3ACPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:51:03 -0500
Message-ID: <1357228255.8203.10.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
From: Matt Fleming <matt.fleming@intel.com>
To: Robin Holt <holt@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Date: Thu, 03 Jan 2013 15:50:55 +0000
In-Reply-To: <20130102210958.GD3470@sgi.com>
References: <20130102172107.GA26761@gulag1.americas.sgi.com>
	 <50E476C2.7060300@zytor.com> <50E486E7.1080903@sgi.com>
	 <20130102210958.GD3470@sgi.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 15:09 -0600, Robin Holt wrote:
> On Wed, Jan 02, 2013 at 01:13:43PM -0600, Nathan Zimmer wrote:
> > On 01/02/2013 12:04 PM, H. Peter Anvin wrote:
> > >On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> > >>I am getting an early boot problem. It only happens on the larger of the
> > >>machines I haven't seen it crop up on machines with more then 512 GB of ram.
> > >>It shows in the latest linus kernel too.
> > >>
> > >>I am (wildly) guessing that what is happening is that the new_memmap that is
> > >>being passed to bios is somehow placed incorrectly.
> > >>I have come up with a workaround.  By placing it the DMA area the issue goes
> > >>away but that doesn't seem like a real fix.
> > >>
> > >What does your memory map look like?
> 
> We reported this a few times (Russ Anderson and I both).  The problem is
> at the point in boot where the efi_enter_virtual_mode callback is, there
> is no identity mapping for most of memory.  If the allocation happens
> to be above the 512GB (or maybe something lower than that) point, the
> BIOS is not able to address this via the physical address passed to it.

Right, looks like efi_call_phys_prelog() needs rewriting to install a
proper identity mapping that actually addresses *all* of available
memory, instead of just the first PGDIR_SIZE bytes.


