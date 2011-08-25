Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1HYMKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:10:01 -0400
Received: from smtp.nokia.com ([147.243.1.47]:38756 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1HYMJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:09:59 -0400
Subject: [xfrm6_mode_transport]: untracked dependency
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 15:06:48 +0300
Message-ID: <1314274008.1339.335.camel@falexey.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.

Looks like module xfrm6_mode_transport should depend on ipv6 module.
While running kernel with ipv6 compiled as a module, and not loaded,
it's impossible to just "modprobe xfrm6_mode_transport", it complains
about wrong address family which is not supported. After manual
inserting ("modprobe ipv6"), subject module can be normally loaded. Same
case with compiled-in kernel IPv6 support: subject module can be
normally loaded.

So the question : what is the proper way to fix this? Normally depmod
should take care of discovering exported and used symbols but modinfo
shows that xfrm6_mode_transport doesn't have a dependency inside. I
didn't find normal way (i.e. like macros MODULE_DEPEND or so) to mark a
dependency manually in module sources.

Best regards
Alexey Fomenko

