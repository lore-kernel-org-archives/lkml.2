Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0JTUX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:23:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:21991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab0JTUXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="618689541"
Message-ID: <4CBF4FD9.2090804@linux.intel.com>
Date: Wed, 20 Oct 2010 13:23:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: fujita.tomonori@lab.ntt.co.jp, JBeulich@novell.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Modularizing IOMMUs (devel/iommu-0.4)
References: <20101020202006.GA30096@dumpdata.com>
In-Reply-To: <20101020202006.GA30096@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 01:20 PM, Konrad Rzeszutek Wilk wrote:
> Hey Peter, Tomo-san, Jan and Jeremy, and LKML:
> 
> I was wondering if I could run this idea by you guys. One of the things that
> Peter proposed was in some ways to "modularize" the IOMMUs (and potentially
> later on use that framework to "modularize" other built-in components). For details:
> http://lkml.org/lkml/2010/8/2/282 and the follow-on threads.
> 
> If you want to look at code right away, I've some beginnings at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/iommu-0.4
> (look at patches past swiotlb-xen: Remove the unnecessary EXPORT_SYMBOL_GPL macros)
> 
> The 10,000 ft view is that during bootup, we want to jettison those IOMMUs
> that are built-in, but actually aren't used b/c the machine does not have it.
> Once it is identified which one we don't want, we mark those sections as available
> for the kernel memory subsystem and we can shed some kilobytes.
> 
> So the first step is to identify the functions for the IOMMUs. And also
> group them tightly together. The path I pursued was to stick all of the
> executable sections in clearly identifiable sections that can be
> easily identified.
> 

I think a much better way to do this is something I discussed with Linus
at least 12 years ago, which is allow modules to be built into the
kernel, but still be unloadable using the actual module mechanism.  This
means they are part of the full kernel image and therefore immediately
available, but appear to the module system as an already-installed
module.  Then we can unload modules to free up space.

This would be a handy thing to have in general, and would simplify this
kind of stuff tremendously.

	-hpa
