Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1AKPS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:18:57 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:33889 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1AKPSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:18:55 -0500
X-Loopcount0: from 10.175.216.251
From: <Narendra_K@Dell.com>
To: <sfr@canb.auug.org.au>
CC: <jbarnes@virtuousgeek.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Narendra_K@Dell.com>,
        <Jordan_Hargrave@Dell.com>, <Matt_Domsch@Dell.com>
Date: Tue, 11 Jan 2011 20:48:21 +0530
Subject: Re: linux-next: build failure after merge of the pci tree
Thread-Topic: linux-next: build failure after merge of the pci tree
Thread-Index: AcuxoshHJzxMMZ4lR6eSLZ5DBXWN2g==
Message-ID: <20110111154214.GA16157@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110110125411.2f45fd2f.sfr@canb.auug.org.au>
In-Reply-To: <20110110125411.2f45fd2f.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 07:24:11AM +0530, Stephen Rothwell wrote:
> Hi Jesse,
> 
> After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `T.647':
> pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
> 
> Caused by commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2 ("PCI: export
> ACPI _DSM provided firmware instance number and string to sysfs").
> 
> I have used the pci tree from next-20110107 for today.

[ It looks like my earlier post did not hit the lists, so reposting ]

Hi, 

I did a git pull of linux-next-20110110 (topmost commit is 
4c897f27ad2668534f719202a3b88abe8ec31011) and applied the patch. With 
CONFIG_DMI and CONFIG_ACPI both set, I did not encounter this build failure. 
The definition for `utf16s_to_utf8s' is available in 'include/linux/nls.h' 
which is included in 'drivers/pci/pci-label.c' and the build succeeded. Sorry 
if I am missing something here.

Stephen,

Could you share the .config which caused this build failure ?

With regards,
Narendra K


