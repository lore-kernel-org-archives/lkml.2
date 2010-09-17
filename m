Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0IQG6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:58:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50048 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0IQG6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=d8ZrKZiNta2kxzJUbj33cgrU9YxxuOVXZ6SZXDh1BXYllrFUi0EWPMiDgkQTrPy9RE
         LUMBRy37ogS8rrj6g18TlZbh4XvOPGLp0J2fA930jYVlZwopZR850W2AT57szLbI+TVJ
         zAH6lcAQ4pzHBI8iJbNESOVIPJ+WWVLX3O1NM=
MIME-Version: 1.0
Date: Fri, 17 Sep 2010 14:58:30 +0800
Message-ID: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
Subject: A simple question of sys_
From: Rofail Qu <rofail@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to use macro IS_ERR() ?

It defines as,
...
#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
static inline long __must_check IS_ERR(const void *ptr)
{
	return IS_ERR_VALUE((unsigned long)ptr);
}
...
so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
valid address),
IS_ERR() will return true!
IS_ERR(x) seems to use on judge if "x" is a valid error number, right?

So in sys_execve(),
...
        long error;
	char* filename;

	filename = getname(name);
	error = PTR_ERR(filename);
	if (IS_ERR(filename))     // <== should be IS_ERR((void *)error) or other?
		return error;
	error = do_execve(filename, argv, envp, regs);
...

Where i am wrong?
Thanks.
