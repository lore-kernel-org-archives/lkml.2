Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2CFPmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:42:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2CFPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:42:23 -0500
Subject: lib/string.h build failure in linux-next
From: Mark Salter <msalter@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 06 Mar 2012 10:42:18 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331048540.17099.9.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a build failure in lib/string.h in linux-next:

/es/linux/linux-next/lib/string.c: In function 'strlcat':
/es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'printk'
/es/linux/linux-next/lib/string.c:225:2: error: implicit declaration of function 'panic'

Commit e2950c2b6ecb928bfd3a13dd237df1f29f712704 removed an include of
linux/module.h which triggered the problem for arch/c6x and probably
other architectures using the asm-generic BUG macro.

I think this needs fixing in asm-generic/bug.h which should include
linux/kernel.h for panic and linux/printk.h for printk.

--Mark


