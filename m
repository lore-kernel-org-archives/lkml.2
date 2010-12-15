Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0LONnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:43:39 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:26703 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab0LONni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:43:38 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288569600"; 
   d="scan'208";a="3360729"
Date: Wed, 15 Dec 2010 13:43:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/11] xen: allow usermode to map granted pages
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1012151341270.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Stefano Stabellini wrote:
> Hi all,
> this patch series introduces the gntdev device that allows usermode
> to map granted pages; gntdev is used by qemu to implement Xen backends
> in userspace.
> 
> Considering that granted pages still have the same entry in the m2p
> as before being granted, the following patches also add a mechanism to
> override portions of the m2p so that we can find out the pfn
> corresponding to the mfn of a granted page in the "receiver" domain.
> This is needed so that we can have pte_page work correctly for these
> pages. Once this requirement is satisfied, __get_user_pages_fast can
> work on granted pages and userspace applications (the xen block backend
> implemented in qemu) can use AIO on them.
> 
> 

I forgot to add that a branch with this series based on 2.6.37-rc5 is
available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc5-gntdev-2

