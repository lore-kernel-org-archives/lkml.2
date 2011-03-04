Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab1CDSrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:47:37 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38044 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759978Ab1CDSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:47:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kOfmlb358jO/xgApt+L9iTBXITe3fhyrCszPUsXhNbdvUWT3eXh8l4PVScooR7S3dATAzzkxNIn2OAn7qxMM+LTcjpoKfUjFAIQ8Ou0VwBvATrhfbzO1idz+8MUA4B8w;
Date: Fri, 4 Mar 2011 10:47:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 4/4] PCI: pre-allocate additional resources to devices
 only after successful allocation of essential resources.
Message-ID: <20110304104730.09ded35f@jbarnes-desktop>
In-Reply-To: <1297734200-23327-5-git-send-email-linuxram@us.ibm.com>
References: <1297734200-23327-1-git-send-email-linuxram@us.ibm.com>
	<1297734200-23327-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 17:43:20 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> Linux tries to pre-allocate minimal resources to hotplug bridges. This
>     works fine as long as there are enough resources  to satisfy all other
>     genuine resource requirements. However if enough resources are not
>     available to satisfy any of these nice-to-have pre-allocations, the
>     resource-allocator reports errors and returns failure.
> 
>     This patch distinguishes between must-have resource from nice-to-have
>     resource.  Any failure to allocate nice-to-have resources are ignored.
> 
>     This behavior can be particularly useful to trigger automatic
>     reallocation when the OS discovers genuine allocation-conflicts
>     or genuine unallocated-requests caused by buggy allocation behavior
>     of the native BIOS/uEFI.
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=15960 captures the movitation
>     behind the patch. This patch is verified to resolve the above bug.

Ok, applied this series.  Everyone please test thoroughly as resource
changes always seem to bite us.

-- 
Jesse Barnes, Intel Open Source Technology Center
