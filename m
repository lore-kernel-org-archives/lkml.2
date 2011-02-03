Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1BCLjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:39:42 -0500
Received: from brother.balabit.com ([195.70.62.219]:60848 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab1BCLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:39:41 -0500
Subject: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 12:39:37 +0100
Message-ID: <1296733177.14846.26.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Back in november, a patch was merged into the kernel (in  commit
ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
CAP_SYS_ADMIN.

Sadly, this has an unwelcomed consequence, that any userspace syslogd
that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
otherwise adapted to the change.

However, updating userspace isn't that easy, either, if one wants to
support multiple kernels with the same userspace binary: pre-2.6.38, one
needs CAP_SYS_ADMIN, but later kernels will need CAP_SYS_ADMIN. It would
be trivial to keep both, but that kind of defeats the purpose of
CAP_SYSLOG, in my opinion. It can be made configurable, and one can let
the admin set which one to use, but that's ugly, and doesn't fix the
underlying issue, just delegates it to the admins. And automatically
deciding runtime proved to be trickier than I would've liked.

My question would be, and this is why I'm CCing the author & committer:
how are userspace syslogds supposed to handle this situation?

Preferably in a way that does not need manual intervention whenever one
changes kernel.

-- 
|8]


