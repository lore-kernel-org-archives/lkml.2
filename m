Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab1EaWfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:35:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:38853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab1EaWfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,299,1304319600"; 
   d="scan'208";a="7523104"
Date: Tue, 31 May 2011 15:35:02 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
Message-ID: <20110531223502.GA8550@xanatos>
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
 <4DE4F166.8020207@gmail.com>
 <20110531171446.GB6776@xanatos>
 <4DE5283A.9070202@gmail.com>
 <20110531181848.GA6911@xanatos>
 <4DE53C74.2080700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE53C74.2080700@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:07:32PM +0200, Maarten Lankhorst wrote:
> Op 31-05-11 20:18, Sarah Sharp schreef:
> > On Tue, May 31, 2011 at 07:41:14PM +0200, Maarten Lankhorst wrote:
> My xhci controller is this one:
> 04:00.0 USB Controller: Device 1b6f:7023 (rev 01) (prog-if 30 [XHCI])
> Subsystem: ASRock Incorporation Device 7023

Ok, the PCI SIGG says that vendor ID is assigned to Etron.  Congrats,
that's the first xHCI host controller I've seen from that company. :)

> After plugging in a simple bluetooth dongle, until the first failure:

Are you sure you have the dmesg log level set to 8?  Because there still
should be more debugging about input and output contexts in this log.
Are you capturing via /var/log/kern.log?

> [  545.440655] xhci_hcd 0000:04:00.0: op reg status = 00000018
> [  545.440659] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
> [  545.440663] xhci_hcd 0000:04:00.0: @bac3f400 01000000 00000000 01000000 00008801
> [  545.440666] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h18, 4'hf);
> [  545.440670] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.440672] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
> [  545.440674] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_port_status
> [  545.440677] xhci_hcd 0000:04:00.0: Port Status Change Event for port 1
> [  545.440682] xhci_hcd 0000:04:00.0: resume root hub
> [  545.440688] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac3f410 (DMA)
> [  545.440697] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_port_status
> [  545.440699] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.440706] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac3f418, 4'hf);
> [  545.440716] usb usb3: usb wakeup-resume
> [  545.440721] usb usb3: usb auto-resume
> [  545.440723] xhci_hcd 0000:04:00.0: resume USB 2.0 root hub
> [  545.440728] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h1, 4'hf);
> [  545.440733] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0430, 32'h2a0, 4'hf);
> [  545.440739] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0434, 32'h0, 4'hf);
> [  545.440744] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2e1, 4'hf);
> [  545.440750] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0424, 32'h0, 4'hf);
> [  545.440757] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0020, 32'h5, 4'hf);
> [  545.450951] hub 3-0:1.0: hub_resume
> [  545.450963] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x202a0
> [  545.450966] xhci_hcd 0000:04:00.0: Get port status returned 0x10100
> [  545.450976] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h202a0, 4'hf);
> [  545.450982] xhci_hcd 0000:04:00.0: clear port connect change, actual port 0 status  = 0x2a0
> [  545.450988] xhci_hcd 0000:04:00.0: get port status, actual port 1 status  = 0x2a0
> [  545.450991] xhci_hcd 0000:04:00.0: Get port status returned 0x100
> [  545.551999] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [  545.560146] xhci_hcd 0000:04:00.0: op reg status = 00000018
> [  545.560150] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
> [  545.560153] xhci_hcd 0000:04:00.0: @bac3f410 01000000 00000000 01000000 00008801
> [  545.560157] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h18, 4'hf);
> [  545.560160] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.560162] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
> [  545.560164] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_port_status
> [  545.560167] xhci_hcd 0000:04:00.0: Port Status Change Event for port 1
> [  545.560172] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac3f420 (DMA)
> [  545.560186] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_port_status
> [  545.560189] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.560195] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac3f428, 4'hf);
> [  545.560206] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
> [  545.560214] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x202e1
> [  545.560217] xhci_hcd 0000:04:00.0: Get port status returned 0x10101
> [  545.560224] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h202e1, 4'hf);
> [  545.560230] xhci_hcd 0000:04:00.0: clear port connect change, actual port 0 status  = 0x2e1
> [  545.560234] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
> [  545.560240] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
> [  545.560242] xhci_hcd 0000:04:00.0: Get port status returned 0x101
> [  545.585947] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
> [  545.585952] xhci_hcd 0000:04:00.0: Get port status returned 0x101
> [  545.611948] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
> [  545.611952] xhci_hcd 0000:04:00.0: Get port status returned 0x101
> [  545.637948] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
> [  545.637952] xhci_hcd 0000:04:00.0: Get port status returned 0x101
> [  545.663952] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x2e1
> [  545.663957] xhci_hcd 0000:04:00.0: Get port status returned 0x101
> [  545.663963] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
> [  545.663967] xhci_hcd 0000:04:00.0: Endpoint state = 0x1
> [  545.663971] xhci_hcd 0000:04:00.0: Command ring enq = 0xbac3f010 (DMA)
> [  545.663973] xhci_hcd 0000:04:00.0: // Ding dong!
> [  545.663976] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce3000, 32'h0, 4'hf);
> [  545.663989] xhci_hcd 0000:04:00.0: op reg status = 00000008
> [  545.663991] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
> [  545.663994] xhci_hcd 0000:04:00.0: @bac3f420 bac3f000 00000000 01000000 01008401
> [  545.663997] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h8, 4'hf);
> [  545.664000] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.664002] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
> [  545.664005] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_cmd_completion
> [  545.664009] xhci_hcd 0000:04:00.0: Command ring deq = 0xbac3f010 (DMA)
> [  545.664012] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_cmd_completion
> [  545.664014] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac3f430 (DMA)
> [  545.664017] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.664023] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac3f438, 4'hf);
> [  545.664034] xhci_hcd 0000:04:00.0: Slot 1 output ctx = 0xbac21000 (dma)
> [  545.664038] xhci_hcd 0000:04:00.0: Slot 1 input ctx = 0xbac22000 (dma)

Ok, so the xHCI driver does successfully get a slot from the host
controller.

> [  545.664041] xhci_hcd 0000:04:00.0: Allocating ring at ffff8801c7d7ccc0
> [  545.664044] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801e2e26c40
> [  545.664047] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac3f800 (virtual) 0xbac3f800 (DMA)
> [  545.664053] xhci_hcd 0000:04:00.0: Linking segment 0xbac3f800 to segment 0xbac3f800 (DMA)
> [  545.664056] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff8801e2e26c40 (virtual), 0xbac3f800 (DMA)
> [  545.664059] xhci_hcd 0000:04:00.0: Set slot id 1 dcbaa entry ffff8800bac3e008 to 0xbac21000
> [  545.664070] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2f1, 4'hf);

But I don't see an Address Device command complete here.  The command
submission probably caused that memory write, but there really should be
more debugging here.  I'll have to look through the hub initialization
and see if there is any error path that would make it skip setting the
device address.

Have you tried on Linux 3.0-rc1?

> [  545.664075] xhci_hcd 0000:04:00.0: set port reset, actual port 0 status  = 0x2f1
> [  545.699907] xhci_hcd 0000:04:00.0: op reg status = 00000018
> [  545.699911] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
> [  545.699915] xhci_hcd 0000:04:00.0: @bac3f430 01000000 00000000 01000000 00008801
> [  545.699918] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h18, 4'hf);
> [  545.699921] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.699923] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
> [  545.699926] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_port_status
> [  545.699928] xhci_hcd 0000:04:00.0: Port Status Change Event for port 1
> [  545.699933] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac3f440 (DMA)
> [  545.699941] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_port_status
> [  545.699943] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.699950] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac3f448, 4'hf);
> [  545.714950] xhci_hcd 0000:04:00.0: get port status, actual port 0 status  = 0x200603
> [  545.714954] xhci_hcd 0000:04:00.0: Get port status returned 0x103
> [  545.765950] xhci_hcd 0000:04:00.0: Resetting device with slot ID 1
> [  545.765955] xhci_hcd 0000:04:00.0: Endpoint state = 0x1
> [  545.765959] xhci_hcd 0000:04:00.0: Command ring enq = 0xbac3f020 (DMA)
> [  545.765961] xhci_hcd 0000:04:00.0: // Ding dong!
> [  545.765964] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce3000, 32'h0, 4'hf);
> [  545.765977] xhci_hcd 0000:04:00.0: op reg status = 00000008
> [  545.765979] xhci_hcd 0000:04:00.0: Event ring dequeue ptr:
> [  545.765982] xhci_hcd 0000:04:00.0: @bac3f440 bac3f010 00000000 c0000000 01008401
> [  545.765985] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0024, 32'h8, 4'hf);
> [  545.765988] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.765990] xhci_hcd 0000:04:00.0: xhci_handle_event - OS owns TRB
> [  545.765992] xhci_hcd 0000:04:00.0: xhci_handle_event - calling handle_cmd_completion
> [  545.765995] xhci_hcd 0000:04:00.0: Completed reset device command.
> [  545.765999] xhci_hcd 0000:04:00.0: Command ring deq = 0xbac3f020 (DMA)
> [  545.766002] xhci_hcd 0000:04:00.0: xhci_handle_event - returned from handle_cmd_completion
> [  545.766005] xhci_hcd 0000:04:00.0: Event ring deq = 0xbac3f450 (DMA)
> [  545.766007] xhci_hcd 0000:04:00.0: In xhci_handle_event
> [  545.766013] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90001ce2038, 64'hbac3f458, 4'hf);
> [  545.766019] xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
> [  545.766023] usb 3-1: Cannot reset HCD device state

Sarah Sharp
