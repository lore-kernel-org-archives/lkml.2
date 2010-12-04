Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0LDKpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 05:45:55 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64995 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0LDKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 05:45:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=QV/K8oYZ7TxFmFsudUG4cPqhFoCkK8LcIu0rgTbgMNneHml2PsWARO3UMgacJUbwp4
         PlEKyNnFGoYBBIv+Dj0nHw3jCmEV/EGyfjtMuPXZVztAW1o80LEzKUa7PHKN9vevA0ax
         DbwnGWNXQPIIdsU1pCRcgV0QORKNXTB5WWYnw=
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Sat, 4 Dec 2010 18:40:14 +0800
X-Google-Sender-Auth: oLgHagQg4D3FFMeW4QaQbyUzky4
Message-ID: <AANLkTi=tEKyo6tJhytCMWPPgXxCDRE10LF2q6W6xwcoM@mail.gmail.com>
Subject: Question about bdi writeback and __filemap_fdatawrite_range()
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are three lists in struct bdi_writeback, b_dirty, b_io and
b_more_io. Once an inode is dirtied, it will be put in b_dirty list.
And once it gets written back, it gets out of the b_io list. And my
question is, if __filemap_fdatawrite_range() kicks off the writeback,
and writes all dirty pages in the inode, how is the inode supposed to
leave the bdi writeback list? I mean, writeback_inodes_wb() will add
the inode to the b_dirty list if no page is written back w/
writeback_single_inode (which is sure, because no dirty page is left).

Is there some piece of code that I am missing?

-- 
Thanks,
-Bergwolf
