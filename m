Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162387Ab2GLWt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:49:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162344Ab2GLWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hugh@veritas.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Badari Pulavarty <pbadari@us.ibm.com>, Nick Piggin <npiggin@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 177/187] mm: Hold a file reference in madvise_remove
Date: Thu, 12 Jul 2012 15:35:33 -0700
Message-Id: <20120712191539.703286827@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 9ab4233dd08036fe34a89c7dc6f47a8bf2eb29eb upstream.

Otherwise the code races with munmap (causing a use-after-free
of the vma) or with close (causing a use-after-free of the struct
file).

The bug was introduced by commit 90ed52ebe481 ("[PATCH] holepunch: fix
mmap_sem i_mutex deadlock")

