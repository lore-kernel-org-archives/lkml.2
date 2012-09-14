Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2INM2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2INM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:28:40 -0400
Date: Fri, 14 Sep 2012 14:30:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Cong Wang <amwang@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jiri Moskovcak <jmoskovc@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm]
	coredump-add-support-for-%d=__get_dumpable-in-core-name-fix
Message-ID: <20120914123034.GA28626@redhat.com>
References: <20120913172817.GA11337@redhat.com> <20120913152559.d0a9ade0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913152559.d0a9ade0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fixes coredump-add-support-for-%d=__get_dumpable-in-core-name.patch)

On 09/13, Andrew Morton wrote:
>
> On Thu, 13 Sep 2012 19:28:17 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > https://bugzilla.redhat.com/show_bug.cgi?id=787135
>
> Needs a RH bugzilla account, so no Reported-by: for you!

OOPS, sorry, I didn't notice. I guess it is private by mistake..

> > This patch adds the new %d specifier for format_corename() which
> > simply reports __get_dumpable(mm->flags), this is compatible with
> > /proc/sys/fs/suid_dumpable we already have.
>
> Please prepare an update to Documentation/sysctl/kernel.txt:core_pattern?

Yes, thanks, please see below.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 Documentation/sysctl/kernel.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..2907ba6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -181,6 +181,8 @@ core_pattern is used to specify a core dumpfile pattern name.
 	%p	pid
 	%u	uid
 	%g	gid
+	%d	dump mode, matches PR_SET_DUMPABLE and
+		/proc/sys/fs/suid_dumpable
 	%s	signal number
 	%t	UNIX time of dump
 	%h	hostname
-- 
1.5.5.1


