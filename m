Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0HISxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:53:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34343 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0HISxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=FB87ISj2qrJ1su4tIP1PThfmLH3sQoGcDKC5XxL1TeN7STfAETIjRnzQ5EsJFDynbo
         t8JWwVEIDguC9NRzRJ8wP3br9r4msPqZmiwr11LO9idAD8Q+x8XtDaXU8oY0CQ76520v
         zLNDFO6QP/QBGlCzPiwKo5mCS4qgipsQLMq7c=
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: section mismatches gone wild
Date: Mon, 9 Aug 2010 14:52:56 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.1; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_I6EYMJGsgkQh+dd"
Message-Id: <201008091452.56313.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_I6EYMJGsgkQh+dd
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Greetings all, from your resident old fart;

I have built 2.6.35.1 about 6 or 7 times, looking for the reason its not 
loading microcode correctly for either my AMD phenom, or my radeon video 
card.  Sometimes a reboot will not startx correctly, hanging with a pure 
white screen and no disk activity.

In watching the rebuilds, there were warnings about section mismatches, 
which I can recall a couple of kernels ago, were only 5.

Unforch, the latest build shows 146.

Its actually running right now, but a capture, with that 
CONFIG_DEBUG_SECTION_MISMATCHES=y in the make command line and a bit of 
redirection returns the attached mismatches.txt.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The most delightful day after the one on which you buy a cottage in
the country is the one on which you resell it.
		-- J. Brecheux

--Boundary-00=_I6EYMJGsgkQh+dd
Content-Type: text/plain;
  charset="UTF-8";
  name="mismatches.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mismatches.txt"

WARNING: arch/x86/pci/built-in.o(.text+0x1180): Section mismatch in reference from the function pcibios_scan_specific_bus() to the function .devinit.text:pci_scan_bus_on_node()
The function pcibios_scan_specific_bus() references
the function __devinit pci_scan_bus_on_node().
This is often because pcibios_scan_specific_bus lacks a __devinit 
annotation or the annotation of pci_scan_bus_on_node is wrong.

WARNING: drivers/char/built-in.o(.data+0x3760): Section mismatch in reference from the variable hvc_con_driver to the function .init.text:hvc_console_setup()
The variable hvc_con_driver references
the function __init hvc_console_setup()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/video/built-in.o(.devinit.text+0xb5): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0xc2): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0xc8): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0xcd): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0xd9): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x119): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x136): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x216): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x22b): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x230): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x245): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x24b): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x276): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x28e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x294): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x29a): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2a0): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2af): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2be): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2c3): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2c9): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2ce): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2d8): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2f4): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x2ff): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x308): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x30e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x314): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x31d): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x32a): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x33a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x346): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x34b): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x352): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x35f): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x364): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x373): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x382): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x38e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x3ae): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x3b7): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x3dd): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x464): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

  LD      drivers/built-in.o
WARNING: drivers/built-in.o(.devinit.text+0x2351): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x235e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2364): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2369): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2375): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x23b5): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x23d2): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x24b2): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x24c7): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x24cc): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x24e1): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x24e7): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2512): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x252a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2530): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2536): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x253c): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x254b): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x255a): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x255f): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2565): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x256a): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2574): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2590): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x259b): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25a4): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25aa): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25b0): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25b9): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25c6): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25d6): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25e2): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25e7): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25ee): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x25fb): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2600): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x260f): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x261e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x262a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x264a): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2653): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2679): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.devinit.text+0x2700): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: drivers/built-in.o(.data+0x5e2c): Section mismatch in reference from the variable hvc_con_driver to the function .init.text:hvc_console_setup()
The variable hvc_con_driver references
the function __init hvc_console_setup()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: vmlinux.o(.text+0x208ff4): Section mismatch in reference from the function pcibios_scan_specific_bus() to the function .devinit.text:pci_scan_bus_on_node()
The function pcibios_scan_specific_bus() references
the function __devinit pci_scan_bus_on_node().
This is often because pcibios_scan_specific_bus lacks a __devinit 
annotation or the annotation of pci_scan_bus_on_node is wrong.

WARNING: vmlinux.o(.devinit.text+0x27fa): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2807): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x280d): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2812): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x281e): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x285e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x287b): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x295b): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2970): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2975): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x298a): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2990): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29bb): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29d3): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29d9): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29df): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29e5): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x29f4): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a03): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a08): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a0e): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a13): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a1d): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a39): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a44): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a4d): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a53): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a59): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a62): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a6f): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a7f): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a8b): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a90): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_defined
The function __devinit efifb_probe() references
a variable __initdata efifb_defined.
If efifb_defined is only used by efifb_probe then
annotate efifb_defined with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2a97): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2aa4): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2aa9): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2ab8): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2ac7): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2ad3): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2af3): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2afc): Section mismatch in reference from the function efifb_probe() to the (unknown reference) .init.data:(unknown)
The function __devinit efifb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by efifb_probe then
annotate (unknown) with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2b22): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.devinit.text+0x2ba9): Section mismatch in reference from the function efifb_probe() to the variable .init.data:efifb_fix
The function __devinit efifb_probe() references
a variable __initdata efifb_fix.
If efifb_fix is only used by efifb_probe then
annotate efifb_fix with a matching annotation.

WARNING: vmlinux.o(.data+0x1bbac): Section mismatch in reference from the variable hvc_con_driver to the function .init.text:hvc_console_setup()
The variable hvc_con_driver references
the function __init hvc_console_setup()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/scsi/mpt2sas/mpt2sas.o(.text+0x9bf8): Section mismatch in reference from the function _scsih_pci_error_detected() to the function .devexit.text:_scsih_remove()
The function _scsih_pci_error_detected() references a function in an exit section.
Often the function _scsih_remove() has valid usage outside the exit section
and the fix is to remove the __devexit annotation of _scsih_remove.

WARNING: drivers/staging/sm7xx/sm7xx.o(.data+0xb44): Section mismatch in reference from the variable smtcfb_driver to the function .init.text:smtcfb_pci_probe()
The variable smtcfb_driver references
the function __init smtcfb_pci_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/video/geode/gx1fb.o(.data+0x54): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe()
The variable gx1fb_driver references
the function __init gx1fb_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/video/via/viafb.o(.devinit.text+0x901): Section mismatch in reference from the function via_pci_probe() to the function .devexit.text:T.632()
The function __devinit via_pci_probe() references
a function __devexit T.632().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
T.632() so it may be used outside an exit section.

WARNING: drivers/net/depca.o(.data+0x0): Section mismatch in reference from the variable depca_isa_driver to the function .init.text:depca_isa_probe()
The variable depca_isa_driver references
the function __init depca_isa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/platform/x86/wmi.o(.data+0xa8): Section mismatch in reference from the variable acpi_wmi_driver to the function .init.text:acpi_wmi_add()
The variable acpi_wmi_driver references
the function __init acpi_wmi_add()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/scsi/mpt2sas/mpt2sas.o(.text+0x9bf8): Section mismatch in reference from the function _scsih_pci_error_detected() to the function .devexit.text:_scsih_remove()
The function _scsih_pci_error_detected() references a function in an exit section.
Often the function _scsih_remove() has valid usage outside the exit section
and the fix is to remove the __devexit annotation of _scsih_remove.

WARNING: drivers/staging/sm7xx/sm7xx.o(.data+0xb44): Section mismatch in reference from the variable smtcfb_driver to the function .init.text:smtcfb_pci_probe()
The variable smtcfb_driver references
the function __init smtcfb_pci_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/staging/vme/devices/vme_user.o(.data+0x10): Section mismatch in reference from the variable vme_user_driver to the function .init.text:vme_user_probe()
The variable vme_user_driver references
the function __init vme_user_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/usb/host/isp1362-hcd.o(.data+0x0): Section mismatch in reference from the variable isp1362_driver to the function .init.text:isp1362_probe()
The variable isp1362_driver references
the function __init isp1362_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/video/geode/gx1fb.o(.data+0x54): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe()
The variable gx1fb_driver references
the function __init gx1fb_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/video/via/viafb.o(.devinit.text+0x901): Section mismatch in reference from the function via_pci_probe() to the function .devexit.text:T.632()
The function __devinit via_pci_probe() references
a function __devexit T.632().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
T.632() so it may be used outside an exit section.

--Boundary-00=_I6EYMJGsgkQh+dd--
