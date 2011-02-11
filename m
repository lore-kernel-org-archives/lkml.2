Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1BKIrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:47:20 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44811 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1BKIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:47:19 -0500
Date: Fri, 11 Feb 2011 09:47:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the edac-amd tree with the tip tree
Message-ID: <20110211084741.GA18661@aftab>
References: <20110211142835.5ef24abe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211142835.5ef24abe.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen,

On Thu, Feb 10, 2011 at 10:28:35PM -0500, Stephen Rothwell wrote:
> Hi Borislav,
> 
> Today's linux-next merge of the edac-amd tree got a conflict in
> include/linux/pci_ids.h between commit
> 41b2610c3443e6c4760e61fc10eef73f96f9f6a5 ("x86, amd: Extend AMD
> northbridge caching code to support "Link Control" devices") from the tip
> tree and commit 3d019f87099415f5f0a2f75b6f828db17e6e9445 ("PCI: Rename
> CPU PCI id define") from the edac-amd tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/linux/pci_ids.h
> index 5aaf45e,5411e7b..0000000
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@@ -517,8 -517,7 +517,8 @@@
>   #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
>   #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
>   #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
> - #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
> + #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
>  +#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604

Yeah, we decided to call all CPU PCI devices on F15h and later simply by
their PCI function numbers for simplicity. I'll fix the .._LINK thing
when all the merging settles after .39-rc1.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
