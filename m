Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1FHVg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:36:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43844 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1FHVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:36:27 -0400
Date: Wed, 8 Jun 2011 22:36:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608213603.GA630@srcf.ucam.org>
References: <20110608195250.GB30256@srcf.ucam.org>
 <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org>
 <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org>
 <4DEFDD69.7010000@kernel.org>
 <20110608204244.GA31484@srcf.ucam.org>
 <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
 <20110608212813.GB32056@srcf.ucam.org>
 <4DEFEA3A.5050604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFEA3A.5050604@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:31:38PM -0700, H. Peter Anvin wrote:
> On 06/08/2011 02:28 PM, Matthew Garrett wrote:
> > 
> > E820 limits us to 128 ranges, and systems I'm looking at right now are 
> > already using over 140 boot services regions. Some of them are 
> > contiguous and we could just merge them for e820, but that leaves us at 
> > the whim of whoever wrote the allocator for the firmware. And do you 
> > want to bet on them having done this sanely?
> > 
> 
> No, we're not limited to 128.  We're limited to 128 in the boot
> structure, but more can be passed via the linked list.

Oh, ok, that's not as bad as I thought. We're still potentially losing a 
pile of memory, but...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
