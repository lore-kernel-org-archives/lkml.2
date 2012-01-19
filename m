Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2ASWXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:23:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab2ASWXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:23:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5cAQVJq858QGi0N_TM91PsKj0jzvUUT8_yA9ezf_wXAQ@mail.gmail.com>
References: <20120118003335.467.71863.stgit@bhelgaas.mtv.corp.google.com>
	<20120118003512.467.60770.stgit@bhelgaas.mtv.corp.google.com>
	<CAE9FiQXvLAJVY-t8EJHkJgugtRsPdT9SS=60vA+by6qMCd5-Wg@mail.gmail.com>
	<CAErSpo7xgJmT=gs8axiY-OseyurqwUEqYixm692kmZAoA-2sNw@mail.gmail.com>
	<CAE9FiQUMEv+=mXzGc_muM_zTQ14S8tVex+bYgyyM1F++37Cu8w@mail.gmail.com>
	<CAErSpo7Awb97fn=bZECqaf4RF4Tmkh1_sUf6_Vk+jgv5jCYNTw@mail.gmail.com>
	<CAE9FiQXj8W4G_SRKCFU-gHJRZ+qENPAs8WAcZA_PVgoageHcoQ@mail.gmail.com>
	<CAErSpo5cAQVJq858QGi0N_TM91PsKj0jzvUUT8_yA9ezf_wXAQ@mail.gmail.com>
Date: Thu, 19 Jan 2012 14:23:10 -0800
X-Google-Sender-Auth: k4OULH9NgiPZT1C9h30yOoD8afo
Message-ID: <CAE9FiQWH0KqsC3Yin0TS+RVCvtjTi6j5wa6aUf19qU3xuQsmOA@mail.gmail.com>
Subject: Re: [PATCH 3/4] PCI: restrict subordinate buses to those reachable
 via host bridge
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 2:13 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Jan 19, 2012 at 1:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> please check attached patch.
>
> It's a pain to comment on attached patches vs. inline ones.

Sorry, gmail does not allow inline patch.

>
> You added bus_max to pci_scan_root_bus().  I'd prefer to pass a
> pointer to a struct resource, as we do for io & mem resources.

Well that depends.

> I'd
> like to move away from pci_scan_root_bus() and toward a
> pci_scan_host_bridge() (as in the patches I posted) that takes all the
> host bridge-related info: parent, domain, resources (including bus
> number range), ops, sysdata.  I don't like the current scheme of
> "create it with defaults and fix them later."

No, struct host bridge is bad idea.  you are tracking host bridge and
peer root bus the same time.

>
> The printk %pR format supports bus numbers so you don't need to print
> them by hand.

later. will remove the debug print.

>
> struct pci_bus already has secondary & subordinate.  I don't think
> adding a "struct resource busn_res" adds useful information except for
> the root bus, where the bus number range comes from something external
> like _CRS rather than from the upstream bridge config.

no, we need that to tracking the busn usage. aka insert them into
iobusn_resource tree.

late it should be convert to list head even. for handling transparent bridge.

>
> This makes pci_scan_bridge() significantly more ugly than it already
> is.  I think it needs to get broken up.

Sure.

Yinghai
