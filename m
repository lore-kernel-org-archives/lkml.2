Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1JFK2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:28:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab1JFK2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:28:05 -0400
Subject: [RFC][PATCH v2][QUILT] Add
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Thu, 06 Oct 2011 12:27:37 +0200
In-Reply-To: <1317750395.18063.11.camel@gandalf.stny.rr.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317896857.29658.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since we're all happily sharing quilt hackery, let me hijack this thread
and share one I've been carrying around for a while.

I use the below patch to run a script like:

#!/bin/bash

if [ -x ./scripts/chechpatch.pl ]; then
        ./scripts/checkpatch.pl $1
fi


---
--- /usr/share/quilt/refresh.orig	2010-02-27 20:42:14.888302809 +0100
+++ /usr/share/quilt/refresh	2010-10-31 12:36:57.355400831 +0100
@@ -310,6 +310,10 @@
 
 cat $tmp_patch >> $tmp_result
 
+if [ -n $QUILT_REFRESH_EXT ] ; then
+	$QUILT_REFRESH_EXT $tmp_result
+fi
+
 mkdir -p $(dirname $patch_file)
 
 if [ -e $patch_file ] && \

