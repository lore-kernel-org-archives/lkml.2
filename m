Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2A0S3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:29:31 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34688 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2A0S3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:29:30 -0500
X-IronPort-AV: E=Sophos;i="4.71,581,1320624000"; 
   d="scan'208";a="10339804"
Date: Fri, 27 Jan 2012 18:30:30 +0000
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] Xen (PV and HVM) multiple PV consoles
Message-ID: <alpine.DEB.2.00.1201271823240.3196@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this small patch series (sent before a few times) achieves two goals:

- make PV consoles work for PV on HVM guests;

- implement support for multiple PV consoles for PV and PV on HVM guests.



Changes in v2:

- nicer safety check in patch #1;

- kzalloc instead of kmalloc;

- removed the spin_lock in vtermno_to_xencons, use
list_for_each_entry_safe.


It has been tested with pv and hvm guests, with console=ttyS0,
console=hvc0, and earlyprintk=xen, with and without serial='pty' in the
VM config file.


Stefano Stabellini (2):
      hvc_xen: support PV on HVM consoles
      hvc_xen: implement multiconsole support

 drivers/tty/hvc/hvc_xen.c          |  455 ++++++++++++++++++++++++++++++++----
 include/xen/interface/hvm/params.h |    6 +-
 2 files changed, 420 insertions(+), 41 deletions(-)


A branch with these patches based on 3.2 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.2-multiconsole-2

Cheers,

Stefano
