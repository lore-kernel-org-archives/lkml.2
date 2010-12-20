Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0LTJtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:49:41 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:53646 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0LTJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Gf/hsq/D7Mi2qapNdJYcn0rUNXmbgRv92cII16NqC5ALSlleJB1+axXQWVWPGoS/4O
         FA8mQL285bkicksoYKBXCDiC3HTK+N0mgHKZfXJhbBtunWpbD62rLOcHR4jC3sYZtfWO
         xA8BvRE+dBl55DsOOvjSkuPYV6fKxjAtq/w4M=
Message-ID: <4D0F26AE.9010205@gmail.com>
Date: Mon, 20 Dec 2010 10:49:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: i915 modeset defunct [was: mmotm 2010-12-16-14-56 uploaded]
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
In-Reply-To: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 11:56 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to

Hi, there is a regression against 2010-12-02-16-34 in i915. When modeset
is used, my G33 produces no signal to the monitor (black screen, power
led blinks).

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
00: 86 80 c0 29 06 00 90 20 02 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c0 29
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 01 00 00 00 01 40 d1 fe 00 00 00 00
50: 00 00 30 02 c9 03 00 00 00 00 00 00 00 00 00 00
60: 01 00 00 e0 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 10 11 11 00 00 33 33 00 5f 00 72 00 00 0a 38 00
a0: 60 00 c0 1c 00 00 80 af 00 00 60 af 00 00 60 af
b0: 00 b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 49 00 00 00 00 00 00 5b
e0: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 90 0f 03 00 00 00 00 00

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
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4161
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915
00: 86 80 c2 29 07 04 90 00 02 00 00 03 00 00 00 00
10: 00 00 b8 fe 01 ec 00 00 08 00 00 d0 00 00 a0 fe
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
30: 00 00 00 00 90 00 00 00 00 00 00 00 05 01 00 00
40: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
50: 00 00 30 02 c9 03 00 00 00 00 00 00 00 00 80 af
60: 00 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 0c 30 e0 fe 61 41 00 00 00 00 00 00
a0: 11 11 00 00 00 00 06 03 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 01 02 00
e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
f0: 12 00 03 00 00 00 00 00 90 0f 03 00 e4 e0 5b af


any ideas?

thanks,
-- 
js
