Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2BGQlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:41:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52829 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:41:06 -0500
Date: Tue, 7 Feb 2012 16:40:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Matthias Schniedermeyer <ms@citd.de>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120207164057.GA29436@srcf.ucam.org>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 08:29:32AM -0800, Linus Torvalds wrote:

> Resulting in a broken system - aspm on the device, but not the bridge
> leading up to it. Which I do not think is a correct situation.

Per spec, it's valid. If there's a bridge that can't deal with its 
downstreams having ASPM enabled when it has ASPM disabled then we 
probably need to quirk that specially.

> (It's also broken because it fundamentally makes the aspm disable be
> "per device", which seems totally wrong - aspm is a system issue, you
> can't just willy-nilly randomly enable it for one device without
> taking other devices into account).

It's at *least* a per-bus thing, not a per-system thing. And, by the 
spec, it's completely valid to have a different set of states configured 
on the bridge and any downstream devices.

> So I suspect the whole pcie_aspm_sanity_check() function should go away.

The sanity check is important because nobody tests ASPM with pre-1.1 
devices. However, in the aspm-is-disabled-by-FADT case, I can believe 
that we should skip it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
