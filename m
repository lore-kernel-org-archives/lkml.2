Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0HSUhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:37:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:56247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0HSUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:37:31 -0400
Date: Thu, 19 Aug 2010 13:34:35 -0700
From: Greg KH <gregkh@suse.de>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 oopses at boot time in kobject allocation
Message-ID: <20100819203435.GA28508@suse.de>
References: <4C6D9289.4000702@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6D9289.4000702@cs.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 04:22:33PM -0400, Benjamin Gilbert wrote:
> 2.6.36-rc1 and 2.6.36-rc1-127-g763008c fail to boot for me:

Can you run 'git bisect' to try to track this down?

> Other observations:
> 
> - Originally the backtrace originated from the yenta driver, so I
> disabled PCMCIA support and it switched to occurring during EHCI
> init.
> 
> - Disabling kmemleak at boot time prevents the "cannot insert" error
> but not the bad kernel paging request.
> 
> - The offending address is "pci:" in little-endian ASCII.

This sounds like a memory overwrite problem somewhere, wierd.

thanks,

greg k-h
