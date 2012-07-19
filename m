Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2GSAjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 20:39:17 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44940 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2GSAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 20:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <5006D810.8090408@stepping-stone.ch>
References: <5006D810.8090408@stepping-stone.ch>
Date: Wed, 18 Jul 2012 17:39:13 -0700
Message-ID: <CAHtARFEd4He1d8=TWBjCXJed-HGM+2XvidBbxe930faGUro2KQ@mail.gmail.com>
Subject: Re: Kernel crash with lspci -vv and SAS Controller LSI Logic /
 Symbios Logic MegaRAID SAS 9240
From: adam radford <aradford@gmail.com>
To: stepping stone GmbH <support@stepping-stone.ch>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/12, stepping stone GmbH <support@stepping-stone.ch> wrote:
...
>
> a tail of lspci -vv http://pastebin.com/kjh8ig9q
>

PCI Config reads from lspci -vvv don't go through the megaraid_sas
driver itself.

It looks like your system hung up while trying to do a PCI Config read
of Capabilities 0xd0: VPD (Vital Product Data).

I have a 9240 controller, and with kernel 3.5.0-rc1, I can do lspci -vvv :

        Capabilities: [d0] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003800
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [138] Power Budgeting <?>
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas

Can you reproduce with kernel 3.5.0-rcX ?  I would also try upgrading
your controller firmware.

-Adam
