Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1EIVfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:35:48 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57803 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754158Ab1EIVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:35:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A6aj3yfMAEqpghCeh5pQjYxV59zFPokWkBLwnh0QT9ZNHwEllMkoCdcXRLTnGLadrH9zXB4khjUYgJoRCTlodpfvE8OkUj+hbPOYPc3IhqXOfH2mzdP12BbwZlL/wFJS;
Date: Mon, 9 May 2011 14:35:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <mjg@redhat.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci, e1000e: Add and use __pci_disable_link_state
Message-ID: <20110509143536.08bd0297@jbarnes-desktop>
In-Reply-To: <4DC6E6E8.9040306@kernel.org>
References: <4DC6E6E8.9040306@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 May 2011 11:54:32 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Need to use it in _e1000e_disable_aspm.
> when aer happens,
> pci_walk_bus already have down_read(&pci_bus_sem)...
> then report_slot_reset
>         ==> e1000_io_slot_reset
>                 ==> e1000e_disable_aspm
>                         ==> pci_disable_link_state...
> 
> We can not use pci_disable_link_state, and it will try to hold pci_bus_sem again.
> 
> Try to have __pci_disable_link_state that will not need to hold pci_bus_sem.

What about the other callers of e1000e_disable_aspm?  Do they already
have the lock held or is it just reset that needs the already locked
version?

> +extern void __pci_disable_link_state(struct pci_dev *pdev, int state);
>  extern void pcie_clear_aspm(void);
>  extern void pcie_no_aspm(void);
>  #else

pci_disable_link_state_locked would be more descriptive and would match
other usage in the kernel.

Thanks,

-- 
Jesse Barnes, Intel Open Source Technology Center
