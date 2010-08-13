Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371Ab0HMPAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:00:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52092 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934510Ab0HMPAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:00:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=m0UzPlFgXzqJPuvY6BWLupp5mjUlLUt3W+s7mfrBbWQtzabh4o0SclmjYzcs4IupPY
         GHXW13N1X7/QNYmAyuYi9VY/Oc2UKPjuM/MQWEC+d4wfJ4n/nA1+7f3AgRi3MZe3EW6K
         NnMGbLuhzBXdM5JlQO3u4NY44YOtvddxakur0=
MIME-Version: 1.0
In-Reply-To: <AANLkTikFd3VZzRD8Rf5bOAH2G=joGUFMMqijC8mtU32V@mail.gmail.com>
References: <AANLkTikFd3VZzRD8Rf5bOAH2G=joGUFMMqijC8mtU32V@mail.gmail.com>
Date: Fri, 13 Aug 2010 10:00:16 -0500
Message-ID: <AANLkTi=mH9qx=EjRZf543OOX-L8vsiKtqj8wBPPuvaRB@mail.gmail.com>
Subject: Fwd: setlocalversion changes trigger regression if build scripts in git
From: Dan McGee <dpmcgee@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 09155120cf0ffe6f0c8aba3aa625831405b65996
Author: Michal Marek <mmarek@suse.cz>
Date:   Thu Jun 17 15:14:58 2010 +0200

   kbuild: Clean up and speed up the localversion logic

This commit causes a regression if you have some of your kernel
building and packaging scripts in git. It can be triggered with
LOCALVERSION_AUTO being enabled or disabled. An example that hopefully
illustrates the situation. The source is simply an extracted tarball
with the 2.6.35.1 patch applied.

dmcgee@dublin ~/projects/eee/kernel-eee/src/linux-2.6.35 (master)
$ grep LOCALVERSION .config
CONFIG_LOCALVERSION="eee"
# CONFIG_LOCALVERSION_AUTO is not set
dmcgee@dublin ~/projects/eee/kernel-eee/src/linux-2.6.35 (master)
$ ./scripts/setlocalversion
eee+
dmcgee@dublin ~/projects/eee/kernel-eee/src/linux-2.6.35 (master)
$ cp -ar . /tmp/not-in-git
dmcgee@dublin ~/projects/eee/kernel-eee/src/linux-2.6.35 (master)
$ cd /tmp/foobar/
dmcgee@dublin /tmp/not-in-git
$ ./scripts/setlocalversion
eee

Note that when in git, you get the appended "+" sign. If
LOCALVERSION_AUTO is set, you will get something like
"eee-gb01b08c-dirty" (whereas the copy of the tree in /tmp still
returns "eee"). It doesn't matter whether the working tree is dirty or
clean.

Is there a way to disable this? I'm building from a clean tarball that
just happens to be unpacked inside a git repository. One would think
setting LOCALVERSION_AUTO to false would do it, but no such luck...

-Dan
