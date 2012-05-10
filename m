Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab2EJVUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:20:23 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:36248 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492Ab2EJVUW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:20:22 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20396.12563.795116.287165@elektron.ikp.physik.tu-darmstadt.de>
Date: Thu, 10 May 2012 23:20:19 +0200
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [opensuse-kernel] 3.4rc6: ACPI change/regression ?
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.5.10.210915
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <201205102031.26807.rjw@sisk.pl> you wrote:
> Hi,
> 
> On Thursday, May 10, 2012, Rafael J. Wysocki wrote:
>> On Wednesday, May 09, 2012, Cristian Rodríguez wrote:
>> > Hi:
>> > 
>> > Since 3.4rc6 I am not able to "turn off" unused Nvidia "optimus" card, 
>> > either with 3rd party modules or vga_switchero.
>> > 
>> > In rc5 it worked fine, now I get:
>> > 
>> > a) with third party bbswitch module.
>> > 
>> > bbswitch: Found integrated VGA device 0000:00:02.0: \_SB_.PCI0.GFX0
>> > bbswitch: Found discrete VGA device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
>> > bbswitch: detected an Optimus _DSM function
>> > bbswitch: disabling discrete graphics
>> > bbswitch: Result of Optimus _DSM call: 11000059
>> > pci 0000:01:00.0: Refused to change power state, currently in D0
>> > ACPI: Device does not support D3
>> > bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is on
>> > 
>> > Ok, third party module may be buggy and I don't expect anyone here to 
>> > support it, so I went to try kernel vga_switchero..
>> > 
>> > VGA switcheroo: switched nouveau off
>> > [drm] nouveau 0000:01:00.0: Disabling display...
>> > [drm] nouveau 0000:01:00.0: Disabling fbcon...
>> > [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
>> > [drm] nouveau 0000:01:00.0: Evicting buffers...
>> > [drm] nouveau 0000:01:00.0: Idling channels...
>> > [drm] nouveau 0000:01:00.0: Suspending GPU objects...
>> > [drm] nouveau 0000:01:00.0: And we're gone!
>> > ACPI: Device does not support D3
>> > 
>> > But device DOES support D3 states or at least it did in rc5..
>> > 
>> > The ill effec of this change is that now the video card fan is running 
>> > almost all the time.
>> > 
>> > Is this a side effect of 
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=1cc0c998fdf2cb665d625fb565a0d6db5c81c639 

> 
> Yes, it's probably this one.  Have you tried to revert it?

Probably the name change ACPI_STATE_D3 -> ACPI_STATE_D3_HOT wasn't
propagated to the nouveau and probaly other driver ...


-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
