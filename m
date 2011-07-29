Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1G2XSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:18:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:38555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G2XSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:18:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,289,1309762800"; 
   d="scan'208";a="33176085"
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	<alpine.DEB.2.00.1107291002570.16178@router.home>
Date: Fri, 29 Jul 2011 16:18:37 -0700
In-Reply-To: <alpine.DEB.2.00.1107291002570.16178@router.home> (Christoph
	Lameter's message of "Fri, 29 Jul 2011 10:04:36 -0500 (CDT)")
Message-ID: <m2pqksznea.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Fri, 29 Jul 2011, Pekka Enberg wrote:
>
>> We haven't come up with a solution to keep struct page size the same but I
>> think it's a reasonable trade-off.
>
> The change requires the page struct to be aligned to a double word
> boundary. 

Why is that?

> There is actually no variable added to the page struct. Its just
> the alignment requirement that causes padding to be added after each page
> struct.

These days with everyone using cgroups (and likely mcgroups too) 
you could probably put the cgroups page pointer back there. It's
currently external.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
