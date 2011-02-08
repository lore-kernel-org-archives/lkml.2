Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1BHUwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:52:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59025 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1BHUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ChltTtFlVMP3o6KCCGqc17ba+cRDW+YPfUjBEPeoINLO8eTW8L8ni4eEO8JEWCs79a
         24khzlXKznlr5ryWiH1PJZiDXAiHgzT6A9GITJ/aRI1N4RM+GTKqVkHX0dNAzB2HUlZR
         3aVLmqf2Wj3jrLfT4iVepbQVTAXwSECFYXGQk=
Message-ID: <4D51AD03.7030401@gmail.com>
Date: Tue, 08 Feb 2011 12:52:19 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com, alexdeucher@gmail.com
Subject: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker
 like its broken or half plugged in
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current HEAD Im getting screen flickering really bad to point 
where it looks like the screen is damaged and/or half plugged-in etc..

the bisect pointed to here:

commit 619efb105924d8cafa0c1dd9389e9ab506f5425d

doing a git revert 619efb10592
gets the screen working properly again.
I havent looked much through the code to see if I can fix this. for the 
time being I'll revert this on my machine with the current, until later on.

lspci -vv shows my card info(let me know if you need anymore)

01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon 
Mobility X1600] (prog-if 00 [VGA controller])
         Subsystem: Apple Computer Inc. MacBook Pro
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 256 bytes
         Interrupt: pin A routed to IRQ 42
         Region 0: Memory at 40000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at 3000 [size=256]
         Region 2: Memory at 50300000 (32-bit, non-prefetchable) [size=64K]
         Expansion ROM at 50320000 [disabled] [size=128K]
         Capabilities: <access denied>
         Kernel driver in use: radeon
         Kernel modules: radeon


Justin P. Mattock
