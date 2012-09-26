Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2IZUr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:47:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2IZUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:47:56 -0400
Date: Wed, 26 Sep 2012 13:47:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120926134755.37b3db32.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jK1i_0t+qGpC0XfE=G1r5qWJDfx2A64T1Yb=w2LDiLW1g@mail.gmail.com>
References: <20120926160127.c34cb6d3e5dcc9ab32e8b573@canb.auug.org.au>
	<CAGXu5jJJPLXP1cjtWAwHNmYQ6ZxtVu=Oo6vh=NkowzT+26RWPg@mail.gmail.com>
	<20120926133335.b012417e.akpm@linux-foundation.org>
	<CAGXu5jK1i_0t+qGpC0XfE=G1r5qWJDfx2A64T1Yb=w2LDiLW1g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012 13:42:05 -0700
Kees Cook <keescook@chromium.org> wrote:

> > +static inline int audit_get_loginuid(struct task_struct *tsk)
> 
> Shouldn't this return kuid_t, due to "userns: Convert the audit
> loginuid  to be a kuid"?

yup, thanks.

--- a/include/linux/audit.h~audith-replace-defines-with-c-stubs-fix
+++ a/include/linux/audit.h
@@ -530,7 +530,7 @@ extern int auditsc_get_stamp(struct audi
 			      struct timespec *t, unsigned int *serial);
 extern int audit_set_loginuid(kuid_t loginuid);
 
-static inline int audit_get_loginuid(struct task_struct *tsk)
+static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return tsk->loginuid
 }
@@ -677,7 +677,7 @@ static inline int auditsc_get_stamp(stru
 {
 	return 0;
 }
-static inline int audit_get_loginuid(struct task_struct *tsk)
+static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
 	return INVALID_UID;
 }
_

