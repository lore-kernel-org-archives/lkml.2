Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2HVMjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:39:46 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36224 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab2HVMjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:39:45 -0400
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 08:39:44 EDT
Date: Wed, 22 Aug 2012 07:14:07 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: linux-alpha@vger.kernel.org, mcree@orcon.net.nz
Subject: [BUG] net/core/sock.c won't compile on alpha
Message-ID: <20120822121407.GA6257@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version 3.6.0-rc2, and probably -rc1 as well.  I get the
following compile-time error on alpha architecture:

(...)
  CC      net/core/sock.o
net/core/sock.c:274:36: error: initializer element is not constant
net/core/sock.c:274:36: error: (near initialization for "memalloc_socks")
net/core/sock.c:274:36: error: initializer element is not constant
make[2]: *** [net/core/sock.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2

Compiler is gcc-4.6.3.

Line 274 of net/core/sock.c is

struct static_key memalloc_socks = STATIC_KEY_INIT_FALSE;

which made its first appearance in 3.6.0-rc1.

--Bob
