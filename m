Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162868Ab2GLXGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:06:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54129 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162849Ab2GLXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:05:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hugh@veritas.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Badari Pulavarty <pbadari@us.ibm.com>, Nick Piggin <npiggin@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [ 66/68] mm: Hold a file reference in madvise_remove
Date: Thu, 12 Jul 2012 16:02:40 -0700
Message-Id: <20120712175041.247517998@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 9ab4233dd08036fe34a89c7dc6f47a8bf2eb29eb upstream.

Otherwise the code races with munmap (causing a use-after-free
of the vma) or with close (causing a use-after-free of the struct
file).

The bug was introduced by commit 90ed52ebe481 ("[PATCH] holepunch: fix
mmap_sem i_mutex deadlock")

[bwh: Backported to 3.2:
 - Adjust context
 - madvise_remove() calls vmtruncate_range(), not do_fallocate()]
[luto: Backported to 3.0: Adjust context]

