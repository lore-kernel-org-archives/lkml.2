Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0ICSCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:02:12 -0400
Received: from xenotime.net ([72.52.115.56]:32951 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756843Ab0ICSCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:02:10 -0400
Date: Fri, 3 Sep 2010 11:01:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Someone Something <fordhaivat@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>, corbet@lwn.net
Subject: Re: LDD examples
Message-Id: <20100903110158.aadf7850.rdunlap@xenotime.net>
In-Reply-To: <AANLkTim7eHwkbbOHdXax7dQiMzSAktxjNYBpQjKOwTUy@mail.gmail.com>
References: <AANLkTim7eHwkbbOHdXax7dQiMzSAktxjNYBpQjKOwTUy@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 18:32:03 -0400 Someone Something wrote:

> I downloaded the LDD examples
> (http://examples.oreilly.com/9780596005900/), and I unzipped the file
> and just tried building it with make just to see if it built properly
> and here are the errors I get:
> setlevel.c:30: error: expected declaration specifiers or '...' before 'type'
> setlevel.c:30: error: expected declaration specifiers or '...' before 'bufp'
> setlevel.c:30: error: expected declaration specifiers or '...' before 'len'
> setlevel.c:30: warning: data definition has no type or storage class
> setlevel.c:30: warning: type defaults to 'int' in declaration of '_syscall3'
> setlevel.c: In function 'main':
> setlevel.c:41: warning: implicit declaration of function 'syslog'
> 
> have any of use experienced these errors? Is this book out of date?
> Alternatives?
> --

The examples are certainly out of date.


'man 2 _syscall' says that it is obsolete and deprecated.

Fixing the userspace programs is easy.  E.g., for setlevel.c, just
#include <unistd.h> 
and change this line:

-_syscall3(int, syslog, int, type, char *, bufp, int, len);
+#define syslog(type, bufp, len)	syscall(8, type, bufp, len)


For the kernel modules, remove
#include <linux/config.h>
from all of them and change CFLAGS to EXTRA_CFLAGS in all Makefiles.

The biggest remaining problem with the kernel modules is scheduled_work
usage and its changing API.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
