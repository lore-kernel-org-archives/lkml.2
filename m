Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HXUvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:51:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33473 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1HXUvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAOtrxKN3sugEcNPb0MkihAJ6P+idAUfGnJBoBq_kwxsDiHdR+A@mail.gmail.com>
References: <20110819175316.GA999@ime.usp.br>
	<CAOtrxKNVckzkxM=ahV13kV=7-Jtj=WWkx_So4pCdVX3e8mdjPw@mail.gmail.com>
	<CA+55aFyyJNnL54o=xRH7CubFLDaQwcF31sqd7tfBcfR8XfnX5g@mail.gmail.com>
	<CAOtrxKN3sugEcNPb0MkihAJ6P+idAUfGnJBoBq_kwxsDiHdR+A@mail.gmail.com>
Date: Wed, 24 Aug 2011 17:51:15 -0300
X-Google-Sender-Auth: n6lrs6Nj6dD9azrUjZ4jBVknyyg
Message-ID: <CAOtrxKMgdSWXRacAy8AVp8q1Zst2NKhvwbUDrhp1pMN5fme9ew@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Thomas Meyer <thomas@m3y3r.de>,
        Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and other people.

2011/8/24 Rogério Brito <rbrito@ime.usp.br>:
> On Aug 24 2011, Linus Torvalds wrote:
>> Oh, I just noticed that the "revert" you did actually does way more than
>> revert.
(...)

Just for the record, I finished compiling the kernel with only the
first part (the real revert) and it works as well as it did with the
2.6.24-rc's:

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 784da9d..1310989 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
                break;

        case PCI_CLASS_BRIDGE_PCI:
+               /* don't size subtractive decoding (transparent)
+                * PCI-to-PCI bridges */
+               if (bus->self->transparent)
+                       break;
                pci_bridge_check_ranges(bus);
                if (bus->self->is_hotplug_bridge) {
                        additional_io_size  = pci_hotplug_io_size;

If there is anything else that you would like me to change or to
provide any extra information, then please let me know and I will do
my best.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
