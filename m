Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab0JOW3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:29:25 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:8914 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0JOW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:29:23 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE9yuEyrR7Hu/2dsb2JhbACDH54RcaROih2SLIEigzN0BIRUhXY
X-IronPort-AV: E=Sophos;i="4.57,338,1283731200"; 
   d="scan'208";a="270312135"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level PCI drivers
Date: Fri, 15 Oct 2010 15:29:13 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        mst@redhat.com
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com> <1285620073.4951.44.camel@x201>
In-Reply-To: <1285620073.4951.44.camel@x201>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151529.13571.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael & Alex et al -
	Sorry for going quiet; I've been digesting the comments and researching a 
lot more stuff.  I plan to release V5 shortly after 2.6.36 is out, highlights 
will be:

1. Re-written pci config tables - using approach suggested by MST to clean 
things up. Looking much better. Also fixed endian issues.
2. Clean up ROM bar handling. Now only read() system call can access rom bar; 
it is always disabled afterwards.
3. Clean up pci_iomap and pci_request_regions handling.  Allocates on demand 
but frees all on close.
4. Resets device on open. Disables, but does not do full reset on close due to 
lock problem with remove() callers.
5. Fixed up memlock rlimit accounting.
6. Lots of small cleanups.

Stay tuned.
I'm also looking at adding PCIe extended capabilities - got a request from a 
cisco project.



