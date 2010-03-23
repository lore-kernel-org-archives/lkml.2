Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0CWPhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:37:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab0CWPha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:37:30 -0400
Message-ID: <4BA8DEEA.7090102@redhat.com>
Date: Tue, 23 Mar 2010 11:31:54 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make kernel-doc ignore __init_or_module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Function definitions may include __init_or_module. kernel-doc needs to
filter those out to avoid confusing __init_or_module for the function name.

Signed-off-by: William cohen <wcohen@redhat.com>
---
 scripts/kernel-doc |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index c7865c3..1d8db58 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1728,6 +1728,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/__init +//;
+    $prototype =~ s/__init_or_module +//;
     $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
-- 
1.6.6.1

