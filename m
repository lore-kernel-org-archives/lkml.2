Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0LBBQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:16:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0LBBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WpyARDTeQt3oUaeeCvjPW7/MovED6dMQkoNqAf0pm8RTqUM54PtiMFFZU1rfm6egYw
         33OFoJlZFAGbFM2UQH6g==
Date: Wed, 1 Dec 2010 17:16:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Alex Bennee <kernel-hacker@bennee.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch] flex_array: export symbols to modules
In-Reply-To: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012011714510.22420@chino.kir.corp.google.com>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Alex Bennee wrote:

> Hi,
> 
> I want to be able to use the flex_array functions in my module so I
> wanted to EXPORT_SYMBOL the API.
> 
> I added the appropriate EXPORT_SYMBOL runes into lib/flex_array.c and
> added externs in the header files but after re-building there is still
> no sign of them in Module.symvers.
> 

You shouldn't need to add any externs in include/linux/flex_array.h, they 
should already be publically declared.

Perhaps you forgot to include linux/module.h in lib/flex_array.c?



flex_array: export symbols to modules

Add EXPORT_SYMBOL() for all publically accessible flex array functions.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/flex_array.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -23,6 +23,7 @@
 #include <linux/flex_array.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -103,6 +104,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_alloc);
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
@@ -126,12 +128,14 @@ void flex_array_free_parts(struct flex_array *fa)
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
 		kfree(fa->parts[part_nr]);
 }
+EXPORT_SYMBOL(flex_array_free_parts);
 
 void flex_array_free(struct flex_array *fa)
 {
 	flex_array_free_parts(fa);
 	kfree(fa);
 }
+EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
 					unsigned int element_nr)
@@ -196,6 +200,7 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_put);
 
 /**
  * flex_array_clear - clear element in array at @element_nr
@@ -223,6 +228,7 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_clear);
 
 /**
  * flex_array_prealloc - guarantee that array space exists
@@ -259,6 +265,7 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_prealloc);
 
 /**
  * flex_array_get - pull data back out of the array
@@ -288,6 +295,7 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+EXPORT_SYMBOL(flex_array_get);
 
 /**
  * flex_array_get_ptr - pull a ptr back out of the array
@@ -308,6 +316,7 @@ void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr)
 
 	return *tmp;
 }
+EXPORT_SYMBOL(flex_array_get_ptr);
 
 static int part_is_free(struct flex_array_part *part)
 {
@@ -348,3 +357,4 @@ int flex_array_shrink(struct flex_array *fa)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_shrink);
