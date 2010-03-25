Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0CYVDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:03:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40575 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754760Ab0CYVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:02:58 -0400
Date: Thu, 25 Mar 2010 17:02:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003251240590.27738@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1003251646170.1808-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Justin Piszcz wrote:

> Ok, done, it froze up again:
> 
> # cat async 
> #
> 
> # cat periodic 
> size = 32
>   0 [117]: ed8/f674a040 (ls dev2 ep1in-int qlen 1 max 8 00083082)
>   1 [ 98]: ed8/f674a0c0 (ls dev3 ep1in-int qlen 1 max 5 00053083)
>   8 [117]: ed8/f674a040
>   9 [ 98]: ed8/f674a0c0
> 16 [117]: ed8/f674a040
> 17 [ 98]: ed8/f674a0c0
> 24 [117]: ed8/f674a040
> 25 [ 98]: ed8/f674a0c0
> 
> # cat registers 
> bus pci, device 0000:00:0b.0
> OHCI Host Controller
> ohci_hcd
> OHCI 1.0, NO legacy support registers
> control 0x68f RWE RWC HCFS=operational IE PLE CBSR=3
> cmdstatus 0x00000 SOC=0
> intrstatus 0x00000024 FNO SF
> intrenable 0x8000004a MIE RHSC RD WDH
> ed_controlhead 3674a080
> hcca frame 0x61e7
> fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
> fmremaining 0x80002565 FRT FR=0x2565
> periodicstart 0x2a2f
> lsthresh 0x0628
> hub poll timer off
> roothub.a 01000208 POTPGT=1 NPS NDP=8(8)
> roothub.b 00000000 PPCM=0000 DR=0000
> roothub.status 00008000 DRWE
> roothub.portstatus [0] 0x00000100 PPS
> roothub.portstatus [1] 0x00000100 PPS
> roothub.portstatus [2] 0x00000100 PPS
> roothub.portstatus [3] 0x00000100 PPS
> roothub.portstatus [4] 0x00000303 LSDA PPS PES CCS
> roothub.portstatus [5] 0x00000303 LSDA PPS PES CCS
> roothub.portstatus [6] 0x00000100 PPS
> roothub.portstatus [7] 0x00000100 PPS

> Anything else worth gathering?
> Does the above output show the problem?

No, it all looks normal.  As a check you could compare this with the
file contents while the mouse is still operating normally.  About the
only difference should be the "hcca frame" line, which changes
constantly.

I guess the next test should be to wait for the mouse to stop working,
unplug the mouse, and then see once again what these files contain.

Alan Stern

