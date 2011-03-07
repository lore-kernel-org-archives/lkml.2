Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1CGOoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:44:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1CGOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:44:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: Add a guideline on notification of new userspace API/ABI elements
Date: Mon, 7 Mar 2011 15:43:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, mtk.manpages@gmail.com,
        linux-kernel@vger.kernel.org
References: <20110307113523.24025.37925.stgit@warthog.procyon.org.uk> <1299508603.20104.30.camel@Joe-Laptop>
In-Reply-To: <1299508603.20104.30.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103071543.56086.arnd@arndb.de>
X-Provags-ID: V02:K0:jQATi1uqXZM+8J7R38PWeqhPW0TPGrtW/ijUI+WfnVx
 ntCkec/19WIEcwgK8hHt5W96Y5BTgtXBBRbmXQR284hjBwPIot
 SGq6BBDa7IZm2r0mYeGcPjzfeftCPzI8/6udSEKqO2I5QPzYuv
 hhwkteYudkGZum1xhvsK2N/qWxG1uK2E9tOnXA0uffPRUxB0+8
 ZOcxXfrO3cy3MBRnvyLvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 March 2011, Joe Perches wrote:
> Hey David.
> 
> Is there some list of files that are more likely to
> trigger this?
> 
> Maybe add a section like:
> 
> USERSPACE ABI/API INTERFACES
> L:      linux-api@vger.kernel.org
> F:      include/asm-generic/errno*.h
> F:      include/linux/capability.h
> F:      include/linux/compat.h
> F:      include/linux/syscalls.h
> F:      include/*/unistd.h

syscalls.h and compat.h are not really the user space ABI,
as user applications don't use those headers to link to
the kernel.

> Maybe add some arch wildcards?
> 
> F:      arch/*/include/asm/errno.h
> F:      arch/*/include/asm/unistd.h
> 
> Maybe add fs?
> 
> F:      fs/compat*.c
> 
> There's probably a bunch of others.
> Suggestions?
> 

I think you can add the entire asm-generic directory. The majority
of the changes in there are to exported files, so they impact
the ABI. For a specific list, you'd have to go through all the
files listed as exported in include/{linux,asm-generic}/Kbuild.

	Arnd
