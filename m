Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2I1B53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:57:29 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:50960 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588Ab2I1Bzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=sasl; b=
	uBMQbfqjA7KO93K2buaj/SzeHm0/piWvbdZksA4s7L4rWr6yTyGJgcx3dWl9Sg7h
	fUW48C2GEotd0uh6Sm85f/aSiJkwCJYx37EgSRrfGp4gMHmK8YqMIM1vRhIyJGmA
	PjUXS4ulIEsxEhYpvn3VXhQX3LCFDqlebx3mbOh0c+8=
From: Daniel Santos <daniel.santos@pobox.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-sparse@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v6 3/25] compiler-gcc.h: Add gcc-recommended GCC_VERSION
 macro
Date: Thu, 27 Sep 2012 20:54:19 -0500
Message-Id: <1348797281-25021-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
X-Pobox-Relay-ID: A282C21C-090F-11E2-84AF-18772E706CDE-06139138!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throughout compiler*.h, many version checks are made.  These can be
simplified by using the macro that gcc's documentation recommends.
However, my primary reason for adding this is that I need bug-check
macros that are enabled at certain gcc versions and it's cleaner to use
this macro than the tradition method:

if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)

If you add patch level, it gets this ugly:

if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
   __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))

As opposed to:

if GCC_VERSION >= 40201

While having separate headers for gcc 3 & 4 eliminates some of this
verbosity, they can still be cleaned up by this.

See also:
http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6a6d7ae..24545cd 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -5,6 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		   + __GNUC_MINOR__ * 100 \
+		   + __GNUC_PATCHLEVEL__)
 
 
 /* Optimization barrier */
-- 
1.7.3.4

