Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2AEOTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:19:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460Ab2AEOTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:19:15 -0500
Date: Thu, 5 Jan 2012 15:19:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120105141913.GA3937@tiehlicka.suse.cz>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
 <20120103130306.GA3891@tiehlicka.suse.cz>
 <20120105110744.GA2222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105110744.GA2222@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-01-12 12:07:45, Stanislaw Gruszka wrote:
[...]
> Only interesting thing we do while resume in the driver is:
> pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00); 
> we do the same during erly stage of .probe function too.
> 
> In the RH bugzilla case, it was regression. There are no iwlegacy
> changes between mentioned kernel versions. There are some APCI and pci
> changes. Can you try if any of these kernel boot parameters helps:
> pcie_aspm=off
> pcie_aspm=force
> pci=nocsr
> pci=use_csr

OK, so I have tried to boot with pcie_aspm=off and the wireless
resurrect. The I found out that I booted into 3.2 rather than 3.2-rc6 so
I retested with the original kernel and guess what, yes it reported the
same problem as before (with or without parameter). 
So I have tried to retest with few kernels (3.2.0-rc5,
3.2.0-rc6-00005-ga36bfdd, 3.2.0-rc7-00083-g115e8e7 and 3.2.0) that I
still had on my machine and 3.2.0-rc6-00005-ga36bfdd seems to be the
only affected one.
There doesn't seem to be any obvious difference wrt. the driver in the
logs (attached).

Looking in the history it seems that 497f16f2 [pci: Fix hotplug of
Express Module with pci bridges] might be related. It fixes an issue
introduced by bbef98ab [PCI: defer enablement of SRIOV BARS] which is a
part of my 3.2.0-rc6-00005-ga36bfdd problematic version. But I do not
understand details of the patch so I cannot tell that for 100%.
Yinghai Lu, is it possible that I the problem I have seen is somehow
related? For reference the thread started at
https://lkml.org/lkml/2011/12/27/65

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
