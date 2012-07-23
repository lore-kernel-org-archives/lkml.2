Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2GWVLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:11:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab2GWVLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:11:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anton Pyrogovskyi <asp@penguinishly.org.ua>
Subject: Re: PROBLEM: Re: [PATCH] pci: Rework ASPM disable code
Date: Mon, 23 Jul 2012 23:17:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "mjg@redhat.com" <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <2806511343077258@web6f.yandex.ru>
In-Reply-To: <2806511343077258@web6f.yandex.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207232317.33764.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 23, 2012, Anton Pyrogovskyi wrote:
> Hello.
> 
> This patch (aka commit 3c076351c, https://lkml.org/lkml/2011/11/10/467) makes my GPU (NVidia GT 240) become undetectable by the NVidia proprietary driver.
> The issue used to surface before, but I resolved it by disabling ASPM altogether (adding «pcie_aspm=off» to the kernel parameter line). This no more works since the commit is in order.
> The driver not being loaded causes me some obvious trouble, such as uvesafb and X not being able to start.
> This only happens during regular boot — if I thaw from hibernation or load the same kernel atop the currently running instance with kexec everything works fine.
> Upon reverting the patch and rebuilding the kernel, everything returns to normal permanently and I can live without kexec again.
> Tested on 3.4.4 and 3.5.0-rc7+, everything earlier than 3.3.x works as expected (due to not having its ASPM disable code reworked).

Well, without knowing what's inside the NVidia driver, we can't really say
what the problem may be.

Does nouveau detect your GPU with the Matthews commit?

Rafael
