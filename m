Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab0I0IuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:50:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938Ab0I0It7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:49:59 -0400
Date: Mon, 27 Sep 2010 10:49:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, eugene@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] proc: making "limits" world readable
Message-ID: <20100927084923.GD1829@jolsa.brq.redhat.com>
References: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
 <20100923145642.49f17b20.akpm@linux-foundation.org>
 <20100924105547.GA1818@jolsa.brq.redhat.com>
 <20100924162007.GD30252@hmsreliant.think-freely.org>
 <20100924113246.1221f435.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924113246.1221f435.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 11:32:46AM -0700, Andrew Morton wrote:
> On Fri, 24 Sep 2010 12:20:07 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Fri, Sep 24, 2010 at 12:55:47PM +0200, Jiri Olsa wrote:
> > > On Thu, Sep 23, 2010 at 02:56:42PM -0700, Andrew Morton wrote:
> > > > On Tue, 21 Sep 2010 11:10:55 +0200
> > > > Jiri Olsa <jolsa@redhat.com> wrote:
> > > > 
> > > > > hi,
> > > > > 
> > > > > I'd like to have the /proc/<pid>/limits file world readable,
> > > > 
> > > > Why?
> > > > 
> > > 
> > > having this will ease the task of system management for large install
> > > bases and where root privileges might be restricted
> > > 
> > > jirka
> > > 
> > I don't see a problem with making this file world readable.  Doing so would be
> > in keeping with most of the other stats bearing files in /proc/<pid>.  The only
> > reason I didn't make it world readable was because the getrlimit sematics
> > previously kept limit information private to the process, and I didn't want to
> > deviate from that.  But as long as we're not making it world writeable I think
> > we're ok.
> > 
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> 
> hm, OK, I can't really think of any realistic problem with exposing limits.
> 
> The original patch had no signoff.  Please resend, with a changelog
> which includes a *good* rationale for making the change.  For example,
> a use case.
> 
thanks for feedback, the patch is attached

jirka

---
making the /proc/<pid>/limits file world readable.

Having the limits file world readable will ease the task of
system management on systems where root privileges might be
restricted. 

Having admin restricted with root proviledges, he/she could
not check other users process' limits.

Also it'd align with most of the /proc stat files.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 fs/proc/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a1c43e7..8e4adda 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2675,7 +2675,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -3011,7 +3011,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	INF("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-- 
1.7.1

