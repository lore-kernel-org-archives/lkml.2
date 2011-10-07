Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab1JGXbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:31:18 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:54355 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1JGXbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:31:17 -0400
Date: Sat, 8 Oct 2011 01:28:42 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linville@tuxdriver.com,
        davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: et131x: Moving the et131x driver out of staging? (a.k.a. filling up the TODO list again)
Message-ID: <20111007232842.GB29770@electric-eye.fr.zoreil.com>
References: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
[...]
> I'd like to propose moving it out of the staging area, or at least
> getting some review comments regarding what work is still needed.

Is there a chance we could have a single file driver - may be with a .h for
the registers layout ? It should be less than 200kbytes, especially if
forward declarations go away.

rx_ring.fbr{0, 1} can probably share a common structure.

Use of kmem_cache seems a bit unusual.

Use dma_alloc_... in place of pci_alloc_...

It's too late stopping the tx queue when there is no room for the current
packet. The condition should be detected for the next packet.

PCI_VDEVICE would not hurt.

My 0.02 € (whatever the CDS spread).

-- 
Ueimor
