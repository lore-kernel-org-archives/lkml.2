Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1APWMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 17:12:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52984 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1APWMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 17:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G44A+IKGtadpR4RvPTnIQ5YogQid6hjA2JdPqmq8bWYIBn/O1+ytQsN5YK9Mw+C1IC
         s6Yjfh3eb4mvMB5B9GfKNDnsG6lBSeYy5l60a+cr55j3UoFlIoS8SaSkAsJ6uaN26O5T
         DH/heCw3C0924v3/j3KN4BiLnVP8P2ZdYp9FA=
MIME-Version: 1.0
Date: Sun, 16 Jan 2011 23:12:53 +0100
Message-ID: <AANLkTikX01vGE2FbXZBxeNszVz7Z4PobqSNmuH0YC5Js@mail.gmail.com>
Subject: Linus' tree as of today (2.6.37-07857-gf8b426b) does not build with !CONFIG_SMP
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: viro@zeniv.linux.org.uk, npiggin@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Nick,

Commit f03c6599 (sanitize vfsmount refcounting changes) breaks the
build when CONFIG_SMP is not set.

fs/namespace.c: In function ‘commit_tree’:
fs/namespace.c:629: error: ‘struct vfsmount’ has no member named ‘mnt_longterm’
...

'mnt_longterm' is only visible when CONFIG_SMP is set.
Commit b3e19d92 (fs: scale mntget/mntput) added CONFIG_SMP to the
vfsmount structure.

-- 
Thanks,
//richard
