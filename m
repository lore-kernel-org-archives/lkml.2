Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0JDAWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 20:22:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41986 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0JDAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 20:22:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 4 Oct 2010 09:16:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: steve@digidescorp.com
Cc: David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
Message-Id: <20101004091653.707cc5d1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1285951267.2558.69.camel@iscandar.digidescorp.com>
References: <WC20101001143139.810346@digidescorp.com>
	<1285929315-2856-1-git-send-email-steve@digidescorp.com>
	<5206.1285943095@redhat.com>
	<5867.1285945621@redhat.com>
	<1285951267.2558.69.camel@iscandar.digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 11:41:07 -0500
"Steven J. Magnani" <steve@digidescorp.com> wrote:
> > However, I suppose there's little harm in letting the patch in.  I would guess
> > the additions all optimise away if memcg isn't enabled.
> > 
> > A question for you: why does struct page_cgroup need a page pointer?  If an
> > array of page_cgroup structs is allocated per array of page structs, then you
> > should be able to use the array index to map between them.
> 
No reason. It was not array in the 1st implemenation and ->page still remains. At 2nd
implementation, I didn't know embeded people has any interests on memcg. And I wasn't
sure how
	page_cgroup_to_page() : pfn_to_page(pagec_cgroup_to_pfn(pc))
will be widely used.

Now, we know page_cgroup->page is not used in very critical path _if_ node-id
and zone-id can be directly got from page_cgroup.

I'm now preparing a patch to remove struct page* pointer. I'm wondering
whether it's ok that some architecuture cannot drop struct page pointer.
If SPARSEMEM is used on 32bit arch, I'm not sure whether # of bits isn't enough.
I may have to add overhead to get nid, zid in critical path.
(for example, s390/32bit, x86-32/HIGHMEM, ARM/HIGHMEM?)

Current out priority is supporting dirty_ratio rather than memory usage diet.
Please wait. Removing page_cgroup->page patch will add something a bit complex.


Thanks,
-Kame

