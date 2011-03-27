Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1C0Cw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 22:52:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61262 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1C0Cwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 22:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=Nw8VdLxBy/cDTxEMpbalKS/QUHu97mNVGSZc/46C3coyx3w3a2kF3yqyxmnc0leIUd
         4CRVZMhaP9/HnpS6vG0Sa6GatRsVyuLh3OfPHmU6QNZ7wwJeLIgTNf7wGx4X9m3IrRjN
         ekXHXjag5ozvNdvFM/8lyEvJfYt8h3SrI7/kY=
Date: Sat, 26 Mar 2011 22:52:50 -0400
From: Celejar <celejar@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: recent kernels misidentify my Broadcom BCM4401-B0
Message-Id: <20110326225250.12547b93.celejar@gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With recent kernels (git pulls of vanillas sources from kernel.org,
mainline and 2.6.38.1), my Broadcom BCM4401-B0 Ethernet card, normally
driven by the b44 driver, has stopped working.  Poking around, I
discovered that the card is (sometimes) no longer correctly identified;
it now (sometimes) shows up (with 'lspci -v' as root) as this bizarre
device:

06:01.0 Network and computing encryption device: Broadcom Corporation Device 0010 (rev 02) (prog-if 10)
        Subsystem: Allied Telesis, Inc Device 0010
        Flags: fast devsel, IRQ 10
        Memory at d0000000 (32-bit, non-prefetchable) [disabled] [size=8K]
        Capabilities: [40] Power Management version 2

This is what it looks like when it's correctly detected:

06:01.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
        Subsystem: Acer Incorporated [ALI] Device 0090
        Flags: bus master, fast devsel, latency 64, IRQ 21
        Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: b44

I'm currently seeing the problem with 2.6.38.1.  What on earth is this
all about?

IIANM, the same kernel will sometimes detect the card correctly, and
sometimes incorrectly; this will make doing a bisection somewhat tricky.

Any suggestions, or further tests I should try, or information I should
provide?

[Please cc. me on replies.]

Celejar
-- 
foffl.sourceforge.net - Feeds OFFLine, an offline RSS/Atom aggregator
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

