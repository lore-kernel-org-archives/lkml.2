Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2LTU2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:28:21 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34256 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2LTU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:28:16 -0500
Date: Thu, 20 Dec 2012 12:28:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] mm/huge_memory: use new hashtable implementation
In-Reply-To: <50D27707.7060309@oracle.com>
Message-ID: <alpine.DEB.2.00.1212201224190.29839@chino.kir.corp.google.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com> <1355756497-15834-4-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212191416410.32757@chino.kir.corp.google.com> <50D27707.7060309@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Sasha Levin wrote:

> In this case, the downside is that you'll waste 8KB if hugepages aren't available,
> but the upside is that you'll have one less dereference when accessing the
> hashtable.
> 
> If the 8KB saving is preferable here I'll drop the patch and come back when
> dynamic hashtable is supported.
> 

If a distro releases with CONFIG_TRANSPARNET_HUGEPAGE=y and a user is 
running on a processor that does not support pse then this just cost them 
8KB for no reason.  The overhead by simply enabling 
CONFIG_TRANSPARENT_HUGEPAGE is worse in this scenario, but this is whole 
reason for having the dynamic allocation in the original code.  If there's 
a compelling reason for why we want this change, then that fact should at 
least be documented.

Could you propose a v2 that includes fixes for the other problems that 
were mentioned?
