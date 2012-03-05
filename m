Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2CELdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 06:33:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53183 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2CELdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 06:33:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.6.203 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F54A46A.6000305@suse.cz>
Date: Mon, 05 Mar 2012 12:32:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
References: <20120304180911.GA7336@kroah.com>
In-Reply-To: <20120304180911.GA7336@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2012 07:09 PM, Greg KH wrote:
> I'm announcing the release of the 2.6.32.58 kernel.
...
> Heiko Carstens (1): compat: fix compile breakage on s390

It's not that minimal it suggests. It removed asm/compat.h inclusion
from arch/s390/kernel/setup.c. This causes build failures on
!CONFIG_COMPAT:
arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
arch/s390/kernel/setup.c:382: error: 'PSW32_ASC_SECONDARY' undeclared
(first use in this function)
arch/s390/kernel/setup.c:382: error: (Each undeclared identifier is
reported only once
arch/s390/kernel/setup.c:382: error: for each function it appears in.)
arch/s390/kernel/setup.c:389: error: 'PSW32_ASC_PRIMARY' undeclared
(first use in this function)

Perhaps asm/compat.h should be included from linux/compat.h
unconditionally...

> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT

But who defines is_compat_task *with* CONFIG_COMPAT on ia64?

fs/autofs4/inode.c: In function 'autofs4_fill_super':
fs/autofs4/inode.c:345: error: implicit declaration of function
'is_compat_task'

thanks,
-- 
js
suse labs
