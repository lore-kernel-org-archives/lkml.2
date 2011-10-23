Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1JWJpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:45:24 -0400
Received: from serv04.lahn.de ([213.239.197.57]:55343 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1JWJpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:45:23 -0400
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Oct 2011 05:45:23 EDT
Date: Sun, 23 Oct 2011 11:21:40 +0200
From: Michael Leun <ml@newton.leun.net>
To: LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Bisected: Massive memory leak in dm-snapshot in 3.1 development
 introduced
Message-ID: <20111023112140.37fd8b3d@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How to reproduce:

lvcreate -L30G -n testsnap vg1 # of course substitute VG as appropriate
dd if=/dev/zero of=/dev/vg1/testsnap bs=2M # to make things clear
lvcreate -L15G -s /dev/vg1/test -n testsnap
dd if=/dev/zero of=/dev/vg1/testsnap bs=2M &
watch free

I noticed roughly 1GB memory vanishing from free / -/+ buffers/cache
per 2GB copied.

Bisecting yielded a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb, reverting
that from git master cures the memory leak

-- 
MfG,

Michael Leun

