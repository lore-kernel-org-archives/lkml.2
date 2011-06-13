Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1FMSAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:00:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37444 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1FMSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:00:20 -0400
Date: Mon, 13 Jun 2011 19:00:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110613180006.GA24902@srcf.ucam.org>
References: <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com>
 <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <20110613164712.GA23343@srcf.ucam.org>
 <4DF64E6A.70700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF64E6A.70700@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:52:42PM +0200, Maarten Lankhorst wrote:
> > +		 */
> > +
> > +		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
> > +		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
> _etext -> _sdata perhaps?

_etext is used for the resource allocation earlier, which seems like 
it's probably the relevant thing to be copying.

> >  		memblock_x86_reserve_range(start, start + size, "EFI Boot");
> >  	}
> >  }
> Will test though. It might also be appropriate to put a WARN when that condition happens.

That'd end up triggering even in cases that are absolutely safe (ie, the 
firmware doesn't have this bug). The amount of suck here is incredible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
