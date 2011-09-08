Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1IHXxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:53:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab1IHXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:52:41 -0400
Date: Thu, 8 Sep 2011 16:52:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
Message-Id: <20110908165230.a7505321.akpm@linux-foundation.org>
In-Reply-To: <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
	<94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 14:28:41 -0400
Jason Baron <jbaron@redhat.com> wrote:

> Replace the repetitive struct _ddebug descriptor definitions with
> a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> 
> ...
>
> +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> +	static struct _ddebug __used __aligned(8)		\
> +	__attribute__((section("__verbose"))) name = {		\
> +		.modname = KBUILD_MODNAME,			\
> +		.function = __func__,				\
> +		.filename = __FILE__,				\
> +		.format = (fmt),				\
> +		.lineno = __LINE__,				\
> +		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
> +		.enabled = false,				\
> +	}

<anal>That macro implements a definition, not a declaration</anal>

--- a/include/linux/dynamic_debug.h~dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix
+++ a/include/linux/dynamic_debug.h
@@ -54,7 +54,7 @@ extern int __dynamic_netdev_dbg(struct _
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
 	static struct _ddebug __used __aligned(8)		\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
@@ -68,7 +68,7 @@ extern int __dynamic_netdev_dbg(struct _
 
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
 				   ##__VA_ARGS__);		\
@@ -76,7 +76,7 @@ do {								\
 
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
 				  ##__VA_ARGS__);		\
@@ -84,7 +84,7 @@ do {								\
 
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
 do {								\
-	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))			\
 		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
 				     ##__VA_ARGS__);		\
_

