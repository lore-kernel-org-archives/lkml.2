Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab0JORH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:07:26 -0400
Received: from claw.goop.org ([74.207.240.146]:48504 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab0JORHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:07:25 -0400
Message-ID: <4CB88A4C.1080305@goop.org>
Date: Fri, 15 Oct 2010 10:07:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH] x86: hold mm->page_table_lock while doing
 vmalloc_sync
References: <4CB76E8B.2090309@goop.org>
In-Reply-To: <4CB76E8B.2090309@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/14/2010 01:56 PM, Jeremy Fitzhardinge wrote:
> Take mm->page_table_lock while syncing the vmalloc region.  This prevents
> a race with the Xen pagetable pin/unpin code, which expects that the
> page_table_lock is already held.  If this race occurs, then Xen can see
> an inconsistent page type (a page can either be read/write or a pagetable
> page, and pin/unpin converts it between them), which will cause either
> the pin or the set_p[gm]d to fail; either will crash the kernel.

I've merged this into tip/x86/mm, which had some conflicting changes
(and fixed up some whitespace issues in one of those changes):

The following changes since commit a416e9e1dde0fbcf20cda59df284cc0dcf2aadc4:

  x86-32: Fix sparse warning for the __PHYSICAL_MASK calculation (2010-10-07 16:36:17 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86-mm

Jeremy Fitzhardinge (2):
      x86/mm: fix bogus whitespace in sync_global_pgds()
      x86: hold mm->page_table_lock while doing vmalloc_sync

 arch/x86/include/asm/pgtable.h |    2 +
 arch/x86/mm/fault.c            |   11 ++++++++-
 arch/x86/mm/init_64.c          |   51 ++++++++++++++++++++++-----------------
 arch/x86/mm/pgtable.c          |   20 +++++++++++++--
 4 files changed, 58 insertions(+), 26 deletions(-)

	J

