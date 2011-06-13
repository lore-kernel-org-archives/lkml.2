Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1FMSSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:18:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42558 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1FMSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:18:11 -0400
Date: Mon, 13 Jun 2011 19:17:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110613181750.GA25372@srcf.ucam.org>
References: <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <20110613164712.GA23343@srcf.ucam.org>
 <4DF64E6A.70700@gmail.com>
 <20110613180006.GA24902@srcf.ucam.org>
 <4DF65372.7090307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF65372.7090307@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 08:14:10PM +0200, Maarten Lankhorst wrote:
> Op 13-06-11 20:00, Matthew Garrett schreef:
> > On Mon, Jun 13, 2011 at 07:52:42PM +0200, Maarten Lankhorst wrote:
> >>> +		 */
> >>> +
> >>> +		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
> >>> +		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
> >> _etext -> _sdata perhaps?
> > _etext is used for the resource allocation earlier, which seems like 
> > it's probably the relevant thing to be copying.
> I meant the second comparison, start <= edata && end >= _etext

I know:

        data_resource.start = virt_to_phys(_etext);
        data_resource.end = virt_to_phys(_edata)-1;

(from kernel/setup.c)

> >>>  		memblock_x86_reserve_range(start, start + size, "EFI Boot");
> >>>  	}
> >>>  }
> >> Will test though. It might also be appropriate to put a WARN when that condition happens.
> > That'd end up triggering even in cases that are absolutely safe (ie, the 
> > firmware doesn't have this bug). The amount of suck here is incredible.
> Still a crapload of swapper BUGs in free_init_pages, maybe you should just give up on this approach,
> and call SetVirtualAddressMap before anything of importance runs. :-/

Not straightforward, sadly. Can I have the dmesg and iomem?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
