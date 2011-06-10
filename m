Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab1FJRyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:54:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42817 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1FJRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:54:43 -0400
Date: Fri, 10 Jun 2011 18:54:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110610175429.GA28500@srcf.ucam.org>
References: <4DE8EF13.9030609@xs4all.nl>
 <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com>
 <4DECFC1C.10801@xs4all.nl>
 <4DED0394.2090000@gmail.com>
 <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com>
 <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF259B2.9070403@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 07:51:46PM +0200, Maarten Lankhorst wrote:
> Well,
> 
> Op 10-06-11 18:47, Matthew Garrett schreef:
> > So this is obviously even more of a hack, but before you check whether 
> > the memblock has already been reserved could you __check_region it as 
> > well? That ought to avoid us touching the kernel. I've got a patch for 
> > grub that'll avoid the situation where we load the kernel on top of an 
> > existing resource and I'll port that to grub2, but that's still going to 
> > be awkward for existing bootloaders.
> >
> Erm, __check_region calls __requestion_region which does a kzalloc,
> if I call __check_region it doesn't boot, probably because of that.

Oh, bother.

> Do you want me to manually run through iomem_resource? Is it even available up at that point?

Should be - we've already called insert_resource to set up the kernel at 
this point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
