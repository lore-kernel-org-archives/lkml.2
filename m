Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2EBEKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:10:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40850 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751011Ab2EBEKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:10:40 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/r/uF1gAjrOjWkBxCGYft5+T7L+XmGa/NzrgmRdV
	FJyhSM5lfmOoua
Message-ID: <4FA0B3BB.1020005@fisher-privat.net>
Date: Wed, 02 May 2012 06:10:35 +0200
From: "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
References: <Pine.LNX.4.44L0.1205011258180.1499-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1205011258180.1499-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.05.2012 18:59, Alan Stern wrote:
> On Tue, 1 May 2012, Oleksij Rempel (fishor) wrote:
>
>>> There also remains a question about runtime power states and resume.
>>>
>>> Oleksij, with your patch, which state does the controller get put into
>>> during runtime suspend, D2 or D3?  (You may need to enable runtime
>>> suspend by doing
>>>
>>> 	echo auto>/sys/bus/pci/devices/0000:00:1d.0/power/control
>>>
>>> in order to test this.)  And if the controller is in runtime suspend,
>>> does it resume correctly when you plug in a new USB device?
>>>
>>> I'm pretty sure that without the patch, the controller gets put into D3
>>> and resume does work.
>>
>> I do not know if device really suspended, but every thing works like
>> before. New usb devices are recognized and working.
>
> You ought to be able to tell the controller's state by looking at the
> dmesg log (after doing the "echo" command above) or the output from
> lspci -v.
>
> Alan Stern
>

looks like it stay in D0 after echo auto > contreol, or even after
"echo 0000:00:1d.0 > /sys/bus/pci/drivers/ehci_hcd/unbind"
Only difference i got is "AFStatus: TP+" after last command changed to 
"TP-". Devices are powersupplied, but not recognized by the OS.


lspci -vvs 00:1d.0
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 1427
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at dfe07000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP+
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
