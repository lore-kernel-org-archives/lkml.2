Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0HXPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:39:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47634 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab0HXPjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:40 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 00/18] Add new semantic patches and reorganize existing ones
Date: Tue, 24 Aug 2010 17:38:54 +0200
Message-Id: <1282664352-15882-1-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds new semantic patches (SPs) in scripts/coccinelle.
Existing SPs are reorganized accordingly.

Nicolas Palix (18):
  Coccinelle: Add null/eno.cocci
  Coccinelle: Add null/kmerr.cocci
  Coccinelle: Move deref_null.cocci to a more appropriate directory
  Coccinelle: Add locks/call_kern.cocci
  Coccinelle: Add locks/double_lock.cocci
  Coccinelle: Add locks/mini_lock.cocci
  Coccinelle: Add iterators/fen.cocci
  Coccinelle: Add iterators/itnull.cocci
  Coccinelle: Add iterators/list_entry_update.cocci
  Coccinelle: Add free/kfree.cocci
  Coccinelle: Add api/kstrdup.cocci
  Coccinelle: Add api/memdup.cocci
  Coccinelle: Add api/memdup_user
  Coccinelle: Move err_cast.cocci to the api directory
  Coccinelle: Move resource_size.cocci to the api directory
  Coccinelle: Move alloc directory into api directory
  Coccinelle: Add misc/doubleinit.cocci
  Coccinelle: Add misc/ifcol.cocci

 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci   |   67 -----
 scripts/coccinelle/alloc/kzalloc-simple.cocci      |   86 ------
 .../coccinelle/api/alloc/drop_kmalloc_cast.cocci   |   67 +++++
 scripts/coccinelle/api/alloc/kzalloc-simple.cocci  |   86 ++++++
 scripts/coccinelle/api/err_cast.cocci              |   56 ++++
 scripts/coccinelle/api/kstrdup.cocci               |   39 +++
 scripts/coccinelle/api/memdup.cocci                |   40 +++
 scripts/coccinelle/api/memdup_user.cocci           |   35 +++
 scripts/coccinelle/api/resource_size.cocci         |   93 ++++++
 scripts/coccinelle/deref_null.cocci                |  293 --------------------
 scripts/coccinelle/err_cast.cocci                  |   56 ----
 scripts/coccinelle/free/kfree.cocci                |  116 ++++++++
 scripts/coccinelle/iterators/fen.cocci             |   64 +++++
 scripts/coccinelle/iterators/itnull.cocci          |   58 ++++
 .../coccinelle/iterators/list_entry_update.cocci   |   62 ++++
 scripts/coccinelle/locks/call_kern.cocci           |   74 +++++
 scripts/coccinelle/locks/double_lock.cocci         |   92 ++++++
 scripts/coccinelle/locks/mini_lock.cocci           |   95 +++++++
 scripts/coccinelle/misc/doubleinit.cocci           |   53 ++++
 scripts/coccinelle/misc/ifcol.cocci                |   48 ++++
 scripts/coccinelle/null/deref_null.cocci           |  293 ++++++++++++++++++++
 scripts/coccinelle/null/eno.cocci                  |   20 ++
 scripts/coccinelle/null/kmerr.cocci                |   72 +++++
 scripts/coccinelle/resource_size.cocci             |   93 ------
 24 files changed, 1463 insertions(+), 595 deletions(-)
 delete mode 100644 scripts/coccinelle/alloc/drop_kmalloc_cast.cocci
 delete mode 100644 scripts/coccinelle/alloc/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
 create mode 100644 scripts/coccinelle/api/alloc/kzalloc-simple.cocci
 create mode 100644 scripts/coccinelle/api/err_cast.cocci
 create mode 100644 scripts/coccinelle/api/kstrdup.cocci
 create mode 100644 scripts/coccinelle/api/memdup.cocci
 create mode 100644 scripts/coccinelle/api/memdup_user.cocci
 create mode 100644 scripts/coccinelle/api/resource_size.cocci
 delete mode 100644 scripts/coccinelle/deref_null.cocci
 delete mode 100644 scripts/coccinelle/err_cast.cocci
 create mode 100644 scripts/coccinelle/free/kfree.cocci
 create mode 100644 scripts/coccinelle/iterators/fen.cocci
 create mode 100644 scripts/coccinelle/iterators/itnull.cocci
 create mode 100644 scripts/coccinelle/iterators/list_entry_update.cocci
 create mode 100644 scripts/coccinelle/locks/call_kern.cocci
 create mode 100644 scripts/coccinelle/locks/double_lock.cocci
 create mode 100644 scripts/coccinelle/locks/mini_lock.cocci
 create mode 100644 scripts/coccinelle/misc/doubleinit.cocci
 create mode 100644 scripts/coccinelle/misc/ifcol.cocci
 create mode 100644 scripts/coccinelle/null/deref_null.cocci
 create mode 100644 scripts/coccinelle/null/eno.cocci
 create mode 100644 scripts/coccinelle/null/kmerr.cocci
 delete mode 100644 scripts/coccinelle/resource_size.cocci

