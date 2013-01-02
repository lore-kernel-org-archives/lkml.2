Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3ABQuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:50:25 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:44837 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3ABQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:50:23 -0500
Message-ID: <1357145418.5429.17.camel@mesosphere.localdomain>
Subject: mmap() scalability in the presence of the MAP_POPULATE flag
From: Roman Dubtsov <dubtsov@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Wed, 02 Jan 2013 23:50:18 +0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 (3.6.2-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrent mmap() calls from the same process are serialized via downing
mm->mmap_sem for write. This means that operations like populating the
pages which do not alter vmas are also performed serially. Anecdotal
data from two machines I have access to is that populating pages by
touching them in a loop outside of mmap() improves performance of the
synthetic micro-benchmark by ~40% in the worst case. A crude patch that
modifies vm_mmap_pgoff() to call make_pages_present() outside of
do_mmap_pgoff() after upping the semaphore when MAP_POPULATE is present
brings identical performance improvement.

Is there an interest in fixing this or concurrent mmaps() from the same
process are too much of a corner case to worry about it?

Regards,
Roma 

