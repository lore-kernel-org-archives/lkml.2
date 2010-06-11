Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0FKWIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:08:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49231 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476Ab0FKWI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nw5x0wLnOlDbCsUI8FIS83Im30mCi7uTTCvHVzhkwxEBXQS8DhBKJXED9E4Wu5mJE1
         tsb/OCw3KWqcehU9hGP8Wu+qaN1Of2VYg52TPClSAzBzs5BnmnPfvrepNy04Vj/Wa30N
         +eW50rN4QwC5cDb4JQBORcxNbNiwStMKNE+Ak=
MIME-Version: 1.0
In-Reply-To: <201006111549.05164.bjorn.helgaas@hp.com>
References: <4BF40014.30303@ntlworld.com>
	<201005201108.07040.bjorn.helgaas@hp.com>
	<201006021058.57361.bjorn.helgaas@hp.com>
	<201006111549.05164.bjorn.helgaas@hp.com>
Date: Fri, 11 Jun 2010 15:08:28 -0700
X-Google-Sender-Auth: BOjpGM_CyVdcQ-j3OV7DLey8Tic
Message-ID: <AANLkTilsQJLv57Uja59C07pq1tZ9RtD03WX-jLhfvUiA@mail.gmail.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, Myron Stowe <myron.stowe@hp.com>,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 2:49 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> [If you haven't been following this bug, the report is at [3].]
>
> Here's a theory.  I'm not an expert in HyperTransport, so maybe somebody
> who knows HyperTransport and/or VIA chipsets can validate or refute it.
>
> This is based on the _HyperTransport I/O Link Specification_, rev 3.10b [1],
> and the _BIOS and Kernel Developer's Guide (BKDG) for AMD Family 10h
> Processors_ [2].
>
> In a nutshell, I think the problem is that amd_bus.c treats a
> HyperTransport (HT) host bridge as though it were a PCI host bridge.  In
> particular, when an HT chain contains more than one PCI host bridge, the
> HT host bridge apertures encompass all the PCI host bridges, but
> amd_bus.c mistakenly assigns all those resources to one PCI host bridge.

I don't think so. that system only have one HT chain.

May 19 23:20:33 ocham kernel: pci 0000:00:18.1 config space:
May 19 23:20:33 ocham kernel: 00: 22 10 01 11 00 00 00 00 00 00 00 06
00 00 80 00
May 19 23:20:33 ocham kernel: 10: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 20: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 30: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 40: 03 00 00 00 00 00 7f 00 00 00 00 00
01 00 00 00
May 19 23:20:33 ocham kernel: 50: 00 00 00 00 02 00 00 00 00 00 00 00
03 00 00 00
May 19 23:20:33 ocham kernel: 60: 00 00 00 00 04 00 00 00 00 00 00 00
05 00 00 00
May 19 23:20:33 ocham kernel: 70: 00 00 00 00 06 00 00 00 00 00 00 00
07 00 00 00
May 19 23:20:33 ocham kernel: 80: 03 00 e0 00 80 ff ef 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: b0: 03 0a 00 00 00 0b 00 00 03 00 80 00
00 ff ff 00
May 19 23:20:33 ocham kernel: c0: 13 10 00 00 00 f0 ff 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: e0: 03 00 00 ff 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: f0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00

the (0xe4) =  ff 00 00 03

mean it will route pci operation all to node0 link0.

that chip from VIA has some design problem that will produce one orphan device.

May 19 23:20:33 ocham kernel: pci 0000:80:01.0 config space:
May 19 23:20:33 ocham kernel: 00: 06 11 88 32 06 00 10 00 10 00 03 04
10 00 00 00
May 19 23:20:33 ocham kernel: 10: 04 c0 bf fe 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 20: 00 00 00 00 00 00 00 00 00 00 00 00
49 18 88 08
May 19 23:20:33 ocham kernel: 30: 00 00 00 00 50 00 00 00 00 00 00 00
0b 01 00 00
May 19 23:20:33 ocham kernel: 40: 00 30 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 50: 01 60 42 c8 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 60: 05 70 80 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 70: 10 00 91 00 00 00 00 00 00 00 30 00
00 00 00 00
May 19 23:20:33 ocham kernel: 80: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: e0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
May 19 23:20:33 ocham kernel: f0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00

YH
