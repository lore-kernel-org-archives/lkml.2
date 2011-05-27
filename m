Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab1E0BC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:02:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:47122 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560Ab1E0BC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:02:57 -0400
Subject: Re: [BUG] OHCI crash when handover fails
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1306454011.7481.529.camel@pasglop>
References: <1306454011.7481.529.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 11:02:48 +1000
Message-ID: <1306458168.7481.531.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 09:53 +1000, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> Current upstream, POWER7 machine running bare metal, there's no BIOS at
> all, so the whole handover failing thing is an oddity in the first place
> which I haven't tracked down yet, but it should cause that crash:

BTW. The same handover failure didn't cause a crash yesterday, so this
is a regression that happened with whatever Linus pulled last night, I
probably won't have a chance to bisect it tho for various reasons.

Cheers,
Ben.

> ohci_hcd 0000:07:02.0: OHCI Host Controller
> ohci_hcd 0000:07:02.0: new USB bus registered, assigned bus number 4
> ohci_hcd 0000:07:02.0: USB HC takeover failed!  (BIOS/SMM bug)
> ohci_hcd 0000:07:02.0: can't setup
> ohci_hcd 0000:07:02.0: USB bus 4 deregistered
> ------------[ cut here ]------------
> kernel BUG at /home/benh/linux-impreza/fs/dcache.c:419!
> cpu 0x0: Vector: 700 (Program Check) at [c0000003dbb9b580]
>     pc: c00000000014848c: .dput+0x50/0x26c
>     lr: c00000000014847c: .dput+0x40/0x26c
>     sp: c0000003dbb9b800
>    msr: 9000000000029032
>   current = 0xc0000003dbc6cec0
>   paca    = 0xc00000000ff88000
>     pid   = 2185, comm = work_for_cpu
> kernel BUG at /home/benh/linux-impreza/fs/dcache.c:419!
> enter ? for help
> [c0000003dbb9b800] c000000000148674 .dput+0x238/0x26c (unreliable)
> [c0000003dbb9b8a0] c0000000004bfd44 .fs_remove_file+0x278/0x2dc
> [c0000003dbb9b970] c0000000004c0374 .usbfs_notify+0x258/0x2e0
> [c0000003dbb9ba20] c000000000602498 .notifier_call_chain+0x6c/0xe0
> [c0000003dbb9bac0] c00000000008ffd4 .__blocking_notifier_call_chain
> +0x60/0x90
> [c0000003dbb9bb70] c0000000004bde70 .usb_notify_remove_bus+0x24/0x3c
> [c0000003dbb9bbf0] c0000000004af760 .usb_deregister_bus+0x80/0xe0
> [c0000003dbb9bc80] c0000000004b1274 .usb_add_hcd+0x6ec/0x750
> [c0000003dbb9bd40] c0000000004bf284 .usb_hcd_pci_probe+0x1e0/0x2b0
> [c0000003dbb9bde0] c000000000304ccc .local_pci_probe+0x34/0x48
> [c0000003dbb9be50] c0000000000809ac .do_work_for_cpu+0x34/0x60
> [c0000003dbb9bed0] c00000000008975c .kthread+0xb0/0xbc
> [c0000003dbb9bf90] c00000000001ce98 .kernel_thread+0x54/0x70
> 0:mon> 
> 
> 
> Cheers,
> Ben.


