Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab0FJV1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 17:27:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42690 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0FJV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 17:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jg8QVOliHDNn5qHP7PhHL0KJyzJNob7o9r3qxwEn8/uVky9FIVba+8CUp52oIWt8Dv
         cnB2HfOupI8g5EiFvOkMwHqeETuVWIjCxMH4Qk2whaQs3hD01KcVEdRQJsiAF6eGi+zr
         u4sN+8U3jTlsJfQc5KNQRzsVnw4HK62FSuO10=
Message-ID: <4C1158AC.9070806@gmail.com>
Date: Thu, 10 Jun 2010 23:27:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: i915 causes bootup freeze (mmotm 2010-06-03-16-36)
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with mmotm 2010-06-03-16-36, I get an ioremap warning caused by i915 and
the bootup freezes. Both w/ and w/o KMS. (W/ KMS I see only black screen.)

The warning with trace:
http://www.fi.muni.cz/~xslaby/sklad/panics/i915_crash.png

I tried this patch just in case, but it doesn't help:
http://lkml.org/lkml/2010/6/6/30


lspci's of bridge and graphics card:

00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31 Express
DRAM Controller [8086:29c0] (rev 02)
        Subsystem: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller [8086:29c0]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0b <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
[VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller [8086:29c2]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4169
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915

thanks,
-- 
js
