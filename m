Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab2AFIte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:49:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab2AFItT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:49:19 -0500
Date: Fri, 6 Jan 2012 09:49:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: iwl3945 didn't survive after s2ram failure
Message-ID: <20120106084916.GA10292@tiehlicka.suse.cz>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
 <20120103103457.GA3391@redhat.com>
 <20120103130306.GA3891@tiehlicka.suse.cz>
 <20120105110744.GA2222@redhat.com>
 <20120105141913.GA3937@tiehlicka.suse.cz>
 <CAE9FiQVi_TN29mUtvHG6ZqWRCkyE6H5eG5z350uXrub=zUmYgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVi_TN29mUtvHG6ZqWRCkyE6H5eG5z350uXrub=zUmYgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-01-12 11:44:17, Yinghai Lu wrote:
> On Thu, Jan 5, 2012 at 6:19 AM, Michal Hocko <mhocko@suse.cz> wrote:
> 
> >
> > Looking in the history it seems that 497f16f2 [pci: Fix hotplug of
> > Express Module with pci bridges] might be related. It fixes an issue
> > introduced by bbef98ab [PCI: defer enablement of SRIOV BARS] which is a
> > part of my 3.2.0-rc6-00005-ga36bfdd problematic version. But I do not
> > understand details of the patch so I cannot tell that for 100%.
> > Yinghai Lu, is it possible that I the problem I have seen is somehow
> > related? For reference the thread started at
> > https://lkml.org/lkml/2011/12/27/65
> 
> you have one bridge that BIOS does not assign resource to it.
> so kernel will allocate resource to it.
> 
> [    0.331694] pci 0000:00:1c.2: BAR 8: assigned [mem 0x80100000-0x803fffff]
> [    0.331825] pci 0000:00:1c.2: BAR 9: assigned [mem
> 0x80400000-0x805fffff 64bit pref]
> [    0.332041] pci 0000:00:1c.2: BAR 7: assigned [io  0x4000-0x4fff]
> [    0.334271] pci 0000:05:00.0: BAR 0: assigned [mem 0x80100000-0x80100fff]
> [    0.334455] pci 0000:05:00.0: BAR 0: set to [mem
> 0x80100000-0x80100fff] (PCI address [0x80100000-0x80100fff])
> [    0.334666] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
> [    0.334794] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
> [    0.334926] pci 0000:00:1c.2:   bridge window [mem 0x80100000-0x803fffff]
> [    0.335058] pci 0000:00:1c.2:   bridge window [mem
> 0x80400000-0x805fffff 64bit pref]
> 
> yes, the commit fix the problem.

Thanks for the confirmation!

> 
> in the commit log i already said:
> 
> |    That should fix regression like BIOS does not assign correct resource to
> |    bridge.
> 
> 
> Thanks
> 
> Yinghai Lu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
