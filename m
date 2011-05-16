Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1EPH7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:59:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56018 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1EPH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:59:39 -0400
Date: Mon, 16 May 2011 00:59:26 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource
 allocation.
Message-ID: <20110516075926.GW8195@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20110509142014.617e3100@jbarnes-desktop>
 <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>
 <4DC9E415.5010402@kernel.org>
 <20110512180638.GA5012@ram-laptop>
 <BANLkTikGG6F22+JEtueF8c5xjX9bBPp+0A@mail.gmail.com>
 <20110512182229.GQ8195@ram-laptop>
 <20110512113726.123fd85b@jbarnes-desktop>
 <BANLkTikt_oWhYHZwVMnrxvow4j+zkPuFCQ@mail.gmail.com>
 <20110512123412.64e9b4cc@jbarnes-desktop>
 <4DCDD589.8010309@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCDD589.8010309@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:06:17PM -0700, Yinghai Lu wrote:
> On 05/12/2011 12:34 PM, Jesse Barnes wrote:
> > On Thu, 12 May 2011 12:18:43 -0700
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Thu, May 12, 2011 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >>>
> >>> Linus, I don't have anything else queued up, so you may as well take
> >>> this one directly if you want it in 2.6.39.  It's a regression fix, but
> >>> resource changes always make me nervous.  Alternately, I could put it
> >>> into 2.6.40 instead, the backport to 2.6.39.x if it survives until
> >>> 2.6.40-rc2 or so...
> >>
> >> Considering the trouble resource allocation always ends up being, I'd
> >> almost prefer that "mark it for stable and put it in the 2.6.40
> >> queue".
> >>
> >> Afaik this problem hasn't actually hit any "normal" users, has it? So ...
> > 
> > Sounds good, thanks.  Yeah I don't think it's hit anyone but Yinghai
> > (at least I don't know of any other reports).
> > 
> 
> please check this one, it should be safe for 2.6.39 ?

>  	size0 = calculate_iosize(size, min_size, size1,
>  			resource_size(b_res), 4096);
> -	size1 = !add_size? size0:
> +	size1 = (!add_head || (add_head && !add_size)) ? size0 :
>  		calculate_iosize(size, min_size+add_size, size1,
>  			resource_size(b_res), 4096);

This solves the problem you encountered.

But, I think, it still does not fix the following scenario:

adjust_resource() failing to allocate additional resource to a hotplug bridge
that has no children. In this case  ->flags of that 'struct resource'
continues to be set even when no resource is allocated to that hot-plug bridge.

RP
