Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2GLGry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:47:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36755 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681Ab2GLGro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:47:44 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] Fix info leaks on export for udf and isofs
Date: Thu, 12 Jul 2012 08:46:53 +0200
Message-Id: <1342075615-24683-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Jan,

this patch set fixes info leaks in isofs and udf. Both file systems fail to
initialize all bytes of the f_handle byte array when creating a handle for a
path pointing to a directory. This memory gets copied to userland and that for
is a leak of uninitialized heap data to userland that should be fixed.

This info leak can be triggered locally by using the name_to_handle_at()
syscall.


Regards,


Mathias Krause (2):
  isofs: avoid info leak on export
  udf: avoid info leak on export

 fs/isofs/export.c |    1 +
 fs/udf/namei.c    |    1 +
 2 files changed, 2 insertions(+)

-- 
1.7.10.4

