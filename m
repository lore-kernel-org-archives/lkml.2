Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2CGInI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:43:08 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54665 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CGInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:43:06 -0500
Date: Wed, 7 Mar 2012 09:42:43 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7] EDAC core changes in order to properly report errors
 from all types of memory controllers
Message-ID: <20120307084243.GB20727@aftab>
References: <4F54A6FF.50502@redhat.com>
 <20120305124411.GD1070@aftab>
 <4F54C133.6040709@redhat.com>
 <20120305141349.GF1070@aftab>
 <4F54D4AF.9060802@redhat.com>
 <4F553764.5070305@redhat.com>
 <20120305232319.GA7175@aftab>
 <4F55F598.7050406@redhat.com>
 <20120306121616.GB11661@aftab>
 <4F56A9CB.2010504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F56A9CB.2010504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 09:20:27PM -0300, Mauro Carvalho Chehab wrote:
> The series now contains:

The below looks like a good way to split this huge patchset into
smaller, much easier to review ones:

> 
> - 2 fix patches over upstream:
>       edac/ppc4xx_edac: Fix compilation
>       i5400_edac: Avoid calling pci_put_device() twice
> 
> - 1 comments improvements:
>       edac: Improve the comments to better describe the memory concepts
> 
> - 1 internal struct renaming patch:
>       edac: rename channel_info to rank_info
> 
> - 6 patches that prepare the internal structures to represent the memory
>   properties per dimm, instead of per csrow. This is needed for modern
>   controllers, where the memories at different channels may be different:
>       edac: Create a dimm struct and move the labels into it
>       edac: Add per dimm's sysfs nodes
>       edac: move dimm properties to struct memset_info
>       edac: Don't initialize csrow's first_page & friends when not needed
>       edac: move nr_pages to dimm struct
>       edac: Add per-dimm sysfs show nodes
> 
> - 2 patches that add proper support for FB-DIMM and for the modern Intel
>   DDR2/DDR3 memory controllers: 
>       edac: Fix core support for MC's that see DIMMS instead of ranks
>       edac: Export MC hierarchy counters for CE and UE
> 
> - 1 log cleanup patch, that prepares for using a MCA based tracepoint:
>       edac: Cleanup the logs for i7core and sb edac drivers
> 
> - 2 debug improvement patches:
>       edac: Add a sysfs node to test the EDAC error report facility
>       edac: Initialize the dimm label with the known information
> 
> - 5 post-FB-DIMM patches that cleans, fix and/or improve a few random things:
>       edac_mc_sysfs: don't create inactive errcount sysfs nodes
>       i5000_edac: Fix the logic that retrieves memory information
>       edac: add a sysfs node that stores the max possible memory location
>       edac: Call the sysfs nodes as "rank" instead of "dimm" if chip select is used
>       i5400_edac: improve debug messages to better represent the filled memory
> 
> - 1 patch that adds a trace event to report memory errors:
>       events/hw_event: Create a Hardware Events Report Mecanism (HERM)

NACK to that last one.

> While the preliminar tests is working ok on the machines I'm testing,
> as I didn't finish the tests yet, some other fix patches may be needed,
> but I'll insert them at the end of the series, as rebasing a large patchset
> like that is very time-consuming.
> 
> So,  I think it is time to merge it at -next, in order to give more visibility
> to it. So, tomorrow, I'll add it there, if I got no complains.

linux-next is not a testing ground for unfinished testing, unreviewed
patches (I'm sure you already knew that), so before you send your stuff
anywhere, it needs to be reviewed by the interested parties. One of
them is me, I'm sure there are others, so please split them in proper
patchsets, as I've already asked you (the above topical split could
work) and send them to edac-devel and people for review.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
