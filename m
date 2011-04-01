Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1DALcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:32:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:56557 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1DALcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.63,281,1299456000"; 
   d="scan'208";a="5094579"
Date: Fri, 1 Apr 2011 12:32:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
In-Reply-To: <4D94FE37.8070109@kernel.org>
Message-ID: <alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Yinghai Lu wrote:
> Stefano, can you explain why it fixes the problem?
> 
> or original patch uncover the bug?

as I wrote in the other email, e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e
removes cleanup_highmap_brk_end but this function was not only dealing
with mappings but it was also setting mmu_cr4_features, therefore the
setting of mmu_cr4_features was lost.

I think the real bug is that mmu_cr4_features ended up in
cleanup_highmap_brk_end by mistake.
