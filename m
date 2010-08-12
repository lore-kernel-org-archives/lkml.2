Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab0HLLgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:36:32 -0400
Received: from smtp-out-205.synserver.de ([212.40.180.205]:1053 "HELO
	smtp-out-205.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753403Ab0HLLg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:36:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 26699
Date: Thu, 12 Aug 2010 13:36:24 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Heinz Diehl <htd@fritha.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100812113624.GB1591@arch.tripp.de>
References: <20100810210941.GA7938@fritha.org>
 <20100810223215.GA1609@arch.tripp.de>
 <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz>
 <20100812091659.GA1591@arch.tripp.de>
 <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 01:18:15PM +0200, Jiri Kosina wrote:
> On Thu, 12 Aug 2010, Markus Trippelsdorf wrote:
> 
> > On Thu, Aug 12, 2010 at 11:11:50AM +0200, Jiri Kosina wrote:
> > > 
> > > Guys, could you please send me your .config with which you are 
> > > experiencing the problem, so that I can try to reproduce it with it?
> > 
> > Attached.
> 
> So I had to add support for HW of mine (SATA_VIA, PATA_VIA, disabled the 
> radeon firmware stuff, and, most importantly, enabled UHCI, which is what 
> is on machine I am using now for testing), and disconnect-connect cycle 
> works nicely:
> 
> usb 3-2: USB disconnect, address 3
> usb 3-2: new low speed USB device using uhci_hcd and address 4
> input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.0/input/input6
> generic-usb 0003:05B8:3091.0004: input,hidraw0: USB HID v1.10 Mouse [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input0
> input: mouse USB mouse with wheel as /devices/pci0000:00/0000:00:10.1/usb3/3-2/3-2:1.1/input/input7
> generic-usb 0003:05B8:3091.0005: input,hidraw1: USB HID v1.10 Keyboard [mouse USB mouse with wheel] on usb-0000:00:10.1-2/input1
> 
> so still no BUG from kobject refcounting, and the hidraw numbers are the 
> same. The major difference seems to be that I am using UHCI and you have 
> your HID devices connected through OHCI, is that correct?

Correct. And I should add that it very easy to reproduce here; just
disconnecting the usb receiver triggers the WARNING.
-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
