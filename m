Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2LTCZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:25:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2LTCZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:25:43 -0500
Message-ID: <50D27707.7060309@oracle.com>
Date: Wed, 19 Dec 2012 21:25:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] mm/huge_memory: use new hashtable implementation
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com> <1355756497-15834-4-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212191416410.32757@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212191416410.32757@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 05:26 PM, David Rientjes wrote:
> This used to be dynamically allocated and would save the 8KB that you 
> statically allocate if transparent hugepages cannot be used.  The generic 
> hashtable implementation does not support dynamic allocation?

No, currently the hashtable only handles statically allocated hashtables.

In this case, the downside is that you'll waste 8KB if hugepages aren't available,
but the upside is that you'll have one less dereference when accessing the
hashtable.

If the 8KB saving is preferable here I'll drop the patch and come back when
dynamic hashtable is supported.


Thanks,
Sasha
