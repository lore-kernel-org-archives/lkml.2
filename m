Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1L2Dew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:34:52 -0500
Received: from ozlabs.org ([203.10.76.45]:59569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1L2Det (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:34:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: linux-next: build warnings after merge of the rr tree
In-Reply-To: <20111228135817.5b92debf636e1fd1c0c68310@canb.auug.org.au>
References: <20111228135817.5b92debf636e1fd1c0c68310@canb.auug.org.au>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 29 Dec 2011 13:46:36 +1030
Message-ID: <87mxacgj8r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Dec 2011 13:58:17 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
Non-text part: multipart/signed
> Hi Rusty,
> 
> After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
> produced these warnings:
> 
> security/apparmor/lsm.c: In function '__check_debug':
> security/apparmor/lsm.c:712:1: warning: return from incompatible pointer type [enabled by default]
> security/apparmor/lsm.c: In function '__check_audit_header':
> security/apparmor/lsm.c:724:1: warning: return from incompatible pointer type [enabled by default]
> security/apparmor/lsm.c: In function '__check_lock_policy':
> security/apparmor/lsm.c:732:1: warning: return from incompatible pointer type [enabled by default]
> security/apparmor/lsm.c: In function '__check_logsyscall':
> security/apparmor/lsm.c:736:1: warning: return from incompatible pointer type [enabled by default]
> security/apparmor/lsm.c: In function '__check_paranoid_load':
> security/apparmor/lsm.c:747:1: warning: return from incompatible pointer type [enabled by default]
> security/apparmor/lsm.c: In function '__check_enabled':
> security/apparmor/lsm.c:751:1: warning: return from incompatible pointer type [enabled by default]

Hmm, I thought the lsm guys had taken the patch for that.

James said he'd applied it.  Repeated below...

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: apparmor: fix module parameter handling

The 'aabool' wrappers actually pass off to the 'bool' parse functions,
so you should use the same check function.  Similarly for aauint and
uint.

(Note that 'bool' module parameters also allow 'int', which is why you
got away with this, but that's changing very soon.)

Cc: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 security/apparmor/lsm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -671,7 +671,7 @@ static struct security_operations apparm
 
 static int param_set_aabool(const char *val, const struct kernel_param *kp);
 static int param_get_aabool(char *buffer, const struct kernel_param *kp);
-#define param_check_aabool(name, p) __param_check(name, p, int)
+#define param_check_aabool param_check_bool
 static struct kernel_param_ops param_ops_aabool = {
 	.set = param_set_aabool,
 	.get = param_get_aabool
@@ -679,7 +679,7 @@ static struct kernel_param_ops param_ops
 
 static int param_set_aauint(const char *val, const struct kernel_param *kp);
 static int param_get_aauint(char *buffer, const struct kernel_param *kp);
-#define param_check_aauint(name, p) __param_check(name, p, int)
+#define param_check_aauint param_check_uint
 static struct kernel_param_ops param_ops_aauint = {
 	.set = param_set_aauint,
 	.get = param_get_aauint
@@ -687,7 +687,7 @@ static struct kernel_param_ops param_ops
 
 static int param_set_aalockpolicy(const char *val, const struct kernel_param *kp);
 static int param_get_aalockpolicy(char *buffer, const struct kernel_param *kp);
-#define param_check_aalockpolicy(name, p) __param_check(name, p, int)
+#define param_check_aalockpolicy param_check_bool
 static struct kernel_param_ops param_ops_aalockpolicy = {
 	.set = param_set_aalockpolicy,
 	.get = param_get_aalockpolicy
