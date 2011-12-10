Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1LJEIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 23:08:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55463 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1LJEIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 23:08:47 -0500
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 06:08:44 +0200
Message-ID: <CAMP44s1gZKKO_BPDcKzsk3hd4ob=S=6UuE0GE6JwwSjC0YSajw@mail.gmail.com>
Subject: Is there something like MODULE_DEPEND?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I've finally found that my problem was that I have to load module
B, before loading module A. The dependency is in the Kconfig file, but
module A doesn't use any symbols from module B, so it's not
automatically loaded.

Apparently FreeBSD has a macro named MODULE_DEPEND for that, which
would make sense.

After reading some code, it seems to me that there's no easy way to
achieve this, as by default there are no symbols that can be found by
modpost, so something like this is needed:

  const const char *module_b;
  EXPORT_SYMBOL(module_b);

note: KBUILD_MODNAME can't be used.

And then, use it in module A:

 extern const char *module_b;
 static const char **test __used = &module_b;

But ultimately, all we want is to add "module_b" to the "depends"
field in the .modinfo section. It should be relatively easy to achieve
by having a special section modpost can detect, and then just put it
into "depends".

Apparently I'm not the first one to have this need[1], but I wonder
why not more people have it.

Cheers.

[1] http://article.gmane.org/gmane.linux.kernel/1183905/match=module_depend

-- 
Felipe Contreras
