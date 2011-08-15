Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1HOUvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:51:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58078 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1HOUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:51:30 -0400
MIME-Version: 1.0
Date: Mon, 15 Aug 2011 23:51:29 +0300
Message-ID: <CAKxaRTKtCOR7WHcpaTaVj8wqGoLpO04Vt3_aJ-Qfk=4X6CW0NQ@mail.gmail.com>
Subject: Linux 3.0.1 compile problem on different locales..
From: =?ISO-8859-1?B?U2VyZGFyIEvWWUzc?= <s.koylux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI.

I download latest stable version and try compile it. But process
terminated with an error message, such as:

error config/modversions.h, file or directory not found (Message is my
original language, in Turkish).

I check manually this file, found it as:

foo/linux-3.0.1/include/config/modversIons.h

And all other "i" chars, translated into "I" chars. I run a grep, find this:

[root@localhost kconfig]# grep -in tolower *.c
confdata.c:730:                 c = tolower(c);

I set env. vars such as "LC_CTYPE=C" manually, retry compile kernel,
yes, it's compiled now.

I don't know best solutions for this problem. A solutions can be write
some warnings in related documents. An other solution, make a patch,
such as:

- confdata.c:730:                 c = tolower(c);
+#define TOLOWER(x) ((x) | 0x20)
+confdata.c:730:                 c = TOLOWER(c);

or makefiles set locale to "C". I don't sure best solution. But this
problem occured in turkish and can be occurred other langs.

Thanks, best regards..
