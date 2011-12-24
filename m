Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1LXDAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 22:00:32 -0500
Received: from shutemov.name ([188.40.19.243]:42426 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1LXDAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 22:00:25 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 3/6] memcg: remove unused variable
Date: Sat, 24 Dec 2011 05:00:16 +0200
Message-Id: <1324695619-5537-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

mm/memcontrol.c: In function ‘mc_handle_file_pte’:
mm/memcontrol.c:5206:16: warning: variable ‘inode’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4bac3a2..627c19e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5203,7 +5203,6 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page = NULL;
-	struct inode *inode;
 	struct address_space *mapping;
 	pgoff_t pgoff;
 
@@ -5212,7 +5211,6 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 	if (!move_file())
 		return NULL;
 
-	inode = vma->vm_file->f_path.dentry->d_inode;
 	mapping = vma->vm_file->f_mapping;
 	if (pte_none(ptent))
 		pgoff = linear_page_index(vma, addr);
-- 
1.7.7.3

