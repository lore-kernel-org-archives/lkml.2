Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2K2TRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:17:01 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58121 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2K2TRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:17:00 -0500
MIME-Version: 1.0
Date: Thu, 29 Nov 2012 11:16:59 -0800
Message-ID: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com>
Subject: Regression with initramfs and nfsroot (appears to be in the dcache)
From: Patrick McLean <patrickm@gaikai.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.6-rc1 and up, when using a (dracut) initramfs with a read-only
nfs root, all accesses to /proc. /sys and /dev return EBUSY.

Bisecting finds this commit as where this was introduced:

> ee3efa91e240f513898050ef305a49a653c8ed90 is the first bad commit
> commit ee3efa91e240f513898050ef305a49a653c8ed90
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Fri Jun 8 15:59:33 2012 -0400
>
>     __d_unalias() should refuse to move mountpoints
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
> :040000 040000 1d6ecde959d3f8252b33f4adff3c4bf1e67f2b92 992ec34563b90fb349957418f76d4673c1af4ab6 M fs
