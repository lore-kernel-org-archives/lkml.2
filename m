Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1EPIAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:00:42 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:38676 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1EPIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:00:40 -0400
Date: Mon, 16 May 2011 09:58:49 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Remove dependency on CONFIG_FLATMEM from online_page()
Message-ID: <20110516075849.GB6393@router-fw-old.local.net-space.pl>
References: <20110502211915.GB4623@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105111547160.24003@chino.kir.corp.google.com> <20110512102515.GA27851@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105121223500.2407@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105121223500.2407@chino.kir.corp.google.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 12, 2011 at 12:26:22PM -0700, David Rientjes wrote:
> On Thu, 12 May 2011, Daniel Kiper wrote:
>
> > > > Memory hotplug code strictly depends on CONFIG_SPARSEMEM.
> > > > It means that code depending on CONFIG_FLATMEM in online_page()
> > > > is never compiled. Remove it because it is not needed anymore.
> > > >
> > > > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> > >
> > > The code you're patching depends on CONFIG_MEMORY_HOTPLUG_SPARSE, so this
> > > is valid.  The changelog should be updated to reflect that, however.
> > >
> > > Acked-by: David Rientjes <rientjes@google.com>
> >
> > No problem, however, this bundle of patches was added to the -mm tree.
> > In this situation should I repost whole bundle with relevant changes
> > or post only those two patches requested by you ??? For which tree
> > should I prepare new version of patches ???
> >
>
> No, I would just reply to the email notification you received when the
> patch went into -mm saying that the changelog should be adjusted to read
> something like
>
> 	online_pages() is only compiled for CONFIG_MEMORY_HOTPLUG_SPARSE,
> 	so there is no need to support CONFIG_FLATMEM code within it.
>
> 	This patch removes code that is never used.

Please look into attachments.

If you have any questions please drop me a line.

Daniel

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch"

>From akpm@linux-foundation.org Wed May  4 01:36:10 2011
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60363 "EHLO
	smtp1.linux-foundation.org" TLS-CIPHER: "EDH-RSA-DES-CBC3-SHA keybits
	168/168 version TLSv1/SSLv3") by router-fw-old.local.net-space.pl
	with ESMTP id S1543901Ab1ECXgK (ORCPT <rfc822;dkiper@net-space.pl>);
	Wed, 4 May 2011 01:36:10 +0200
Received-SPF: pass (router-fw.net-space.pl: domain of linux-foundation.org designates 140.211.169.13 as permitted sender) client-ip=140.211.169.13; envelope-from=akpm@linux-foundation.org; helo=smtp1.linux-foundation.org;
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p43NZt8T007131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Tue, 3 May 2011 16:35:55 -0700
Received: from localhost.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id p43NZsk4017523;
	Tue, 3 May 2011 16:35:54 -0700
Message-Id: <201105032335.p43NZsk4017523@imap1.linux-foundation.org>
Subject: + mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch added to -mm tree
To:	mm-commits@vger.kernel.org
Cc:	dkiper@net-space.pl, dave@linux.vnet.ibm.com
From:	akpm@linux-foundation.org
Date:	Tue, 03 May 2011 16:35:54 -0700
X-Spam-Status: No, hits=-102.983 required=5 tests=AWL,BAYES_00,USER_IN_WHITELIST
X-Spam-Checker-Version:	SpamAssassin 3.2.4-osdl_revision__1.47__
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13
X-Bogosity: No, spamicity=0.433210
Return-Path: <akpm@linux-foundation.org>
X-Envelope-To: <"|/usr/bin/procmail -m /home/dkiper/.procmailrc"> (uid 4000)
X-Orcpt: rfc822;dkiper@net-space.pl
Original-Recipient: rfc822;dkiper@net-space.pl
Status: RO
Content-Length: 3134
Lines: 82


The patch titled
     mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
has been added to the -mm tree.  Its filename is
     mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
From: Daniel Kiper <dkiper@net-space.pl>

set_page_section() is valid only in CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP context.  Move it to proper place and amend
accordingly functions which are using it.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap include/linux/mm.h
--- a/include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap
+++ a/include/linux/mm.h
@@ -682,6 +682,12 @@ static inline struct zone *page_zone(str
 }
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+static inline void set_page_section(struct page *page, unsigned long section)
+{
+	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
+	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
+}
+
 static inline unsigned long page_to_section(struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
@@ -700,18 +706,14 @@ static inline void set_page_node(struct 
 	page->flags |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_section(struct page *page, unsigned long section)
-{
-	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
-	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
-}
-
 static inline void set_page_links(struct page *page, enum zone_type zone,
 	unsigned long node, unsigned long pfn)
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 	set_page_section(page, pfn_to_section_nr(pfn));
+#endif
 }
 
 /*
_

Patches currently in -mm which might be from dkiper@net-space.pl are

linux-next.patch
mm-remove-dependency-on-config_flatmem-from-online_page.patch
mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch
mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch



--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mm-remove-dependency-on-config_flatmem-from-online_page.patch"

>From akpm@linux-foundation.org Wed May  4 01:36:13 2011
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60493 "EHLO
	smtp1.linux-foundation.org" TLS-CIPHER: "EDH-RSA-DES-CBC3-SHA keybits
	168/168 version TLSv1/SSLv3") by router-fw-old.local.net-space.pl
	with ESMTP id S1543901Ab1ECXgN (ORCPT <rfc822;dkiper@net-space.pl>);
	Wed, 4 May 2011 01:36:13 +0200
Received-SPF: pass (router-fw.net-space.pl: domain of linux-foundation.org designates 140.211.169.13 as permitted sender) client-ip=140.211.169.13; envelope-from=akpm@linux-foundation.org; helo=smtp1.linux-foundation.org;
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p43NZrg5007125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Tue, 3 May 2011 16:35:53 -0700
Received: from localhost.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id p43NZqv0017520;
	Tue, 3 May 2011 16:35:53 -0700
Message-Id: <201105032335.p43NZqv0017520@imap1.linux-foundation.org>
Subject: + mm-remove-dependency-on-config_flatmem-from-online_page.patch added to -mm tree
To:	mm-commits@vger.kernel.org
Cc:	dkiper@net-space.pl, dave@linux.vnet.ibm.com
From:	akpm@linux-foundation.org
Date:	Tue, 03 May 2011 16:35:52 -0700
X-Spam-Status: No, hits=-102.983 required=5 tests=AWL,BAYES_00,USER_IN_WHITELIST
X-Spam-Checker-Version:	SpamAssassin 3.2.4-osdl_revision__1.47__
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13
X-Bogosity: No, spamicity=0.406815
Return-Path: <akpm@linux-foundation.org>
X-Envelope-To: <"|/usr/bin/procmail -m /home/dkiper/.procmailrc"> (uid 4000)
X-Orcpt: rfc822;dkiper@net-space.pl
Original-Recipient: rfc822;dkiper@net-space.pl
Status: RO
Content-Length: 2122
Lines: 59


The patch titled
     mm: remove dependency on CONFIG_FLATMEM from online_page()
has been added to the -mm tree.  Its filename is
     mm-remove-dependency-on-config_flatmem-from-online_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove dependency on CONFIG_FLATMEM from online_page()
From: Daniel Kiper <dkiper@net-space.pl>

Memory hotplug code strictly depends on CONFIG_SPARSEMEM.  It means that
code depending on CONFIG_FLATMEM in online_page() is never compiled. 
Remove it because it is not needed anymore.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-dependency-on-config_flatmem-from-online_page
+++ a/mm/memory_hotplug.c
@@ -374,10 +374,6 @@ void online_page(struct page *page)
 		totalhigh_pages++;
 #endif
 
-#ifdef CONFIG_FLATMEM
-	max_mapnr = max(pfn, max_mapnr);
-#endif
-
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
_

Patches currently in -mm which might be from dkiper@net-space.pl are

linux-next.patch
mm-remove-dependency-on-config_flatmem-from-online_page.patch
mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch
mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch



--HlL+5n6rz5pIUxbD--
