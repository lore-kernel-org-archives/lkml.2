Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2AKVMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:12:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53955 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089Ab2AKVMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:12:36 -0500
Message-ID: <1326316354.6774.12.camel@joe2Laptop>
Subject: checkpatch regression: error on #define pr_fmt(fmt) KBUILD_MODNAME
 ": " fmt
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2012 13:12:34 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current checkpatch gives:

ERROR: Macros with complex values should be enclosed in parenthesis
#18: FILE: net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:18:
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

due to:

commit b3dfb9bc52e9a751e47bbc92d3a3f07e9a0029c5
Author: Andy Whitcroft <apw@canonical.com>
Date:   Thu Dec 22 16:04:25 2011 +1100

    checkpatch: correctly track the end of preprocessor commands in context
    
    When looking for a statement we currently run on through preprocessor
    commands.  This means that a header file with just definitions is parsed
    over and over again combining all of the lines from the current line to
    the end of file leading to severe performance issues.
    
    Fix up context accumulation to track preprocessor commands and stop when
    reaching the end of them.  At the same time vastly simplify the #define
    handling.
    


