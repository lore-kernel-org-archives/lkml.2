Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0CXRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:33:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35097 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab0CXRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=N6p6M4TdDM7WQQUNwWLnpvxAT+cVDn5LXBksguoG4FPu8qs5ZotYvGzr725tELkv/K
         7GEgSknudqyf6TUuNuWJHNV6Pjh9lhhxb4eX5SdCg6vGRn99cQ0MvmY25xA+Q5nfMONa
         yAt3sTLtOKGcQoj/JvqT2tunccJmSbgVGb1iw=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, hch@infradead.org, mkp@mkp.net,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/5] blkdev: discard optimizations v2 RESEND2
Date: Wed, 24 Mar 2010 20:33:03 +0300
Message-Id: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow. lkml seem don't like 'XXX' in the subject
So post it one more time.

This is second version of generic discard optimizations
first was submitted here: http://lwn.net/Articles/373994

Currently there are many file-systems which has implemented
discard support, but SSD discs not widely used yet.
This patch-set introduce compat helpers which simulate
discard requests with zeroing semantics.

__blkdev_issue_zeroout: explicitly zeroout given range via write request.
blkdev_issue_clear: zeroout given range, use discard request if possible.

Later filesystem admin may select which behavior is suitable for his needs
discard without zeroing or explicit zeroing even if discard is not supported.

Advantages:
- Hope that this helps in real filesystem testing.
- People who are crazy about data security would be really happy.
- Virtual machine developers also would like this feature.

Other optimization:
- Convert all blkdev_issue_xxx function to common set of flags
- Optimize generic discard submitting procedure.

