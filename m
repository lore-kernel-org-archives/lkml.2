Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1IWLQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:16:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28483 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1IWLQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:16:16 -0400
X-IronPort-AV: E=Sophos;i="4.68,429,1312171200"; 
   d="scan'208";a="164425892"
Message-ID: <4E7C6B18.7030100@citrix.com>
Date: Fri, 23 Sep 2011 12:18:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 0/6] xen: don't call vmalloc_sync_all()
 when mapping foreign pages
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com> <4E727017.4030001@goop.org> <alpine.DEB.2.00.1109211124050.8700@kaball-desktop> <4E7A3394.3090806@goop.org> <alpine.DEB.2.00.1109221131390.8700@kaball-desktop> <4E7BA677.9090907@goop.org>
In-Reply-To: <4E7BA677.9090907@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/09/11 22:19, Jeremy Fitzhardinge wrote:
> 
> But I'd be happier pretending that vmalloc_sync_* just doesn't exist,
> and deal with it at the hypercall level - in the short term, by just
> making sure that the callers touch all those pages before passing them
> into the hypercall.

I don't think you can access the pages at the addresses allocated with
alloc_vm_area() because the pages don't exist yet and there's a check of
pte_present() in vmalloc_fault() and I think an Oops will be reported.

David
