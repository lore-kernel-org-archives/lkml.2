Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1EBVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:25:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48065 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab1EBVZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:25:12 -0400
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from
 online_page()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 02 May 2011 14:25:04 -0700
Message-ID: <1304371504.30823.45.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 23:19 +0200, Daniel Kiper wrote:
> Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
> It means that code depending on CONFIG_FLATMEM in online_page()
> is never compiled. Remove it because it is not needed anymore.

It's subtle, but I don't think that's true.  We had another hotplug mode
for x86_64 before folks were comfortable turning SPARSEMEM on for the
whole architecture.  It was quite possible to have memory hotplug
without sparsemem in that case.  I think Keith Mannthey did some of that
code if I remember right.

But, I'm not sure how much of that stayed in distros versus made it
upstream.  In any case, you might want to chase down the
X86_64_ACPI_NUMA bit to make sure it can't be used with FLATMEM ever.

config MEMORY_HOTPLUG
        bool "Allow for memory hot-add"
        depends on SPARSEMEM || X86_64_ACPI_NUMA
        depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
        depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)

-- Dave

