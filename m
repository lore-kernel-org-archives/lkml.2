Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0HPToL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:44:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34471 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0HPToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=lNPErJJk0lu6xSn3qpWebNoQ7alxqIrB8NViR2Deh80n6dNHjaONFsv86xoxhISFOP
         7u0E6qTHbypfqrYaN1ERbUhnzSfvWO7E1xVkvAw+UIlqgagSt5gO2+18cFIDbjWGibHm
         B7fcOobOXMn9PZMNZc7y8F3DdJ2MdP8i96pc4=
MIME-Version: 1.0
Date: Mon, 16 Aug 2010 15:44:09 -0400
X-Google-Sender-Auth: aMuDsRU72K1D3ib4QxGVSKws37g
Message-ID: <AANLkTimGueKYoP_qkZ3j94OKj0wCk_XGH0m30bQqb55X@mail.gmail.com>
Subject: Inotify doesn't detect splice system call?
From: Oussama El Mfadli <oussama.el-mfadli@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Robert Love <rlove@rlove.org>,
        John McCutchan <john@johnmccutchan.com>,
        Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently monitoring file open and modification with inotify. The
tool works perfectly went the file is modify by using a write system
call. But now, I'm using the splice system call to benefit from the
zero-copy mechanism.

The files are perfectly modified, but inotify system call doesn't
detect it. In the read_write.c file, the modification is signalled by
calling "fsnotify_modify(...)" in the vfs_write function. In the file
splice.c, the function is not called when a file is written.

>From what I have understood, the inotify system call has been
integrated to the kernel in the mainline from the release 2.6.13, but
the splice system call has been included later (2.6.17).

Is it a Bug that inotify doesn't support splice() or is there some
considerations that explain it?

Thanks
