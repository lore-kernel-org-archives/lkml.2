Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1AaKuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:50:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1AaKuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:50:52 -0500
Message-ID: <4D4693CF.9090903@suse.de>
Date: Mon, 31 Jan 2011 16:19:51 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Shilovsky <piastryyy@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
References: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
In-Reply-To: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 08:00 AM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> fs/cifs/file.c: In function 'cifs_iovec_write':
> fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' from incompatible pointer type
> fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argument is of type 'size_t *'
> 
> Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS:
> Implement cifs_strict_writev (try #4)").
> 

The following patch should silence that warning.

From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type

fs/cifs/file.c: In function ‘cifs_iovec_write’:
fs/cifs/file.c:1740:9: warning: passing argument 6 of ‘CIFSSMBWrite2’ from incompatible pointer type
fs/cifs/cifsproto.h:343:12: note: expected ‘unsigned int *’ but argument is of type ‘size_t *’

Cc: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0de17c1..2a3c5d8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1667,7 +1667,7 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written = 0, written = 0;
+	unsigned int total_written = 0, written = 0;
 	unsigned long num_pages, npages;
 	size_t copied, len, cur_len, i;
 	struct kvec *to_send;
