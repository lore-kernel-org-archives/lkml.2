Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab0LUDGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 22:06:14 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:37864 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab0LUDGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 22:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=hJqqIUOrV4ad3aETzp4m9x7uLb3mqEMYS7UdSuCmlSGnDW5qvE/w8xQDj0wefzhQ9Z
         p7oxT732tHbQHOOr9JTyBJNb6yi5midyXJvh2fpDLi5yAbYDnEy2m6LzyM0NjtXCgGl0
         GQNNql/S0dYuO8y930Zkio6DIdl0XqWBWgpfg=
MIME-Version: 1.0
From: AJ ONeal <coolaj86@gmail.com>
Date: Mon, 20 Dec 2010 20:05:51 -0700
Message-ID: <AANLkTimze4agnNRM_HVnQ1=B44pWy_D+OmeUYFvCSwMy@mail.gmail.com>
Subject: Memory Leak in /dev/shm on ARM 2.6.36
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my other message about SIGBUS I was mmap-ing a file in /dev/shm.

I switched my implementation to use write() instead of mmap and now it
leaks memory very very quickly.

`df -h` shows that 80mb of memory are in use
`du -ch /dev/shm` shows that 10mb of memory in use

After just a few minutes of creating and removing 512kb files in
/dev/shm the program exits with a write failure.
Unmounting and remounting /dev/shm reclaims the memory.

Again, if there is a better place to discuss this kind of bug, please
point me to it.

AJ ONeal
