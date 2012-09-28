Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031387Ab2I1Tgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:36:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50498 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965347Ab2I1TAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jovi Zhang <boojovi@gmail.com>, Youquan Song <youquan.song@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [ 135/262] MIPS: mm: Add compound tail page _mapcount when mapped
Date: Fri, 28 Sep 2012 11:51:04 -0700
Message-Id: <20120928183013.966553627@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jovi Zhang <bookjovi@gmail.com>

commit af89fa3986b9d034a286544ab1ed95096496a2f9 upstream.

See commit b6999b191 which did the same modification for x86's mm/gup,

Quote from commit b6999b191:
    "If compound pages are used and the page is a
    tail page, gup_huge_pmd() increases _mapcount to record tail page are
    mapped while gup_huge_pud does not do that."

[ralf@linux-mips.org: fixed rejects caused by the original patch getting
linewrapped.]

Signed-off-by: Jovi Zhang <boojovi@gmail.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Patchwork: https://patchwork.linux-mips.org/patch/4291/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -152,6 +152,8 @@ static int gup_huge_pud(pud_t pud, unsig
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;


