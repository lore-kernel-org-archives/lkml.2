Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0LCS7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 13:59:04 -0500
Received: from claw.goop.org ([74.207.240.146]:39346 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab0LCS7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 13:59:02 -0500
Message-ID: <4CF93DF3.90908@goop.org>
Date: Fri, 03 Dec 2010 10:58:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [GIT PULL] Xen fixes
References: <4CF92911.8060704@goop.org>
In-Reply-To: <4CF92911.8060704@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 09:29 AM, Jeremy Fitzhardinge wrote:
> Hi Linus,
>
> Another handful of Xen fixes:

Oh, could you also pull:

  git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-fixes

Stefano Stabellini (5):
      xen: use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
      xen: fix MSI setup and teardown for PV on HVM guests
      xen: resume the pv console for hvm guests too
      xen: fix save/restore for PV on HVM guests with pirq remapping
      xen: unplug the emulated devices at resume time

 arch/x86/pci/xen.c                 |   27 +++++++---
 arch/x86/xen/platform-pci-unplug.c |    2 +-
 arch/x86/xen/suspend.c             |    1 +
 arch/x86/xen/xen-ops.h             |    2 +-
 drivers/xen/events.c               |  105 +++++++++++++++++++++++++-----------
 drivers/xen/manage.c               |    1 +
 include/xen/events.h               |    7 ++-
 include/xen/interface/physdev.h    |   10 ++++
 8 files changed, 114 insertions(+), 41 deletions(-)


Which fixes various bugs when running in "fully virtualized +
paravirtualizations" mode:

    * removes the use of a never-implemented experimental Xen ABI, and
      replaces it with the one that did finally get implemented
    * make MSI work on passed-through devices
    * various save/restore fixes (console, interrupts, emulated device
      unplugging)

Thanks,
    J
