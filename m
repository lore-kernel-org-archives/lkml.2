Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2AEToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:44:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52507 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120105141913.GA3937@tiehlicka.suse.cz>
References: <20111227105340.GD5344@tiehlicka.suse.cz>
	<20120103103457.GA3391@redhat.com>
	<20120103130306.GA3891@tiehlicka.suse.cz>
	<20120105110744.GA2222@redhat.com>
	<20120105141913.GA3937@tiehlicka.suse.cz>
Date: Thu, 5 Jan 2012 11:44:17 -0800
X-Google-Sender-Auth: 15jPAPttnS22uzE4B95-nCzLV-c
Message-ID: <CAE9FiQVi_TN29mUtvHG6ZqWRCkyE6H5eG5z350uXrub=zUmYgA@mail.gmail.com>
Subject: Re: iwl3945 didn't survive after s2ram failure
From: Yinghai Lu <yinghai@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:19 AM, Michal Hocko <mhocko@suse.cz> wrote:

>
> Looking in the history it seems that 497f16f2 [pci: Fix hotplug of
> Express Module with pci bridges] might be related. It fixes an issue
> introduced by bbef98ab [PCI: defer enablement of SRIOV BARS] which is a
> part of my 3.2.0-rc6-00005-ga36bfdd problematic version. But I do not
> understand details of the patch so I cannot tell that for 100%.
> Yinghai Lu, is it possible that I the problem I have seen is somehow
> related? For reference the thread started at
> https://lkml.org/lkml/2011/12/27/65

you have one bridge that BIOS does not assign resource to it.
so kernel will allocate resource to it.

[    0.331694] pci 0000:00:1c.2: BAR 8: assigned [mem 0x80100000-0x803fffff]
[    0.331825] pci 0000:00:1c.2: BAR 9: assigned [mem
0x80400000-0x805fffff 64bit pref]
[    0.332041] pci 0000:00:1c.2: BAR 7: assigned [io  0x4000-0x4fff]
[    0.334271] pci 0000:05:00.0: BAR 0: assigned [mem 0x80100000-0x80100fff]
[    0.334455] pci 0000:05:00.0: BAR 0: set to [mem
0x80100000-0x80100fff] (PCI address [0x80100000-0x80100fff])
[    0.334666] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.334794] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.334926] pci 0000:00:1c.2:   bridge window [mem 0x80100000-0x803fffff]
[    0.335058] pci 0000:00:1c.2:   bridge window [mem
0x80400000-0x805fffff 64bit pref]

yes, the commit fix the problem.

in the commit log i already said:

|    That should fix regression like BIOS does not assign correct resource to
|    bridge.


Thanks

Yinghai Lu
