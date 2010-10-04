Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0JDRcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:32:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33713 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0JDRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ro2ivyLPvDM91GBkmOZIifAaM/WVL41hXFCDQGrGlhpR61V5ezBfLBVH+BS/Z0iFvS
         A9ROdV9Ha94La4kTkmWuN3RYS9nT5jBn4tKj4UPmwFq4mgnDadOzav9gHZK7EpUWjo31
         hn0cYhuYRKpjgI17S20ONrMu1NZKXbkfMvulI=
From: Sami Kerola <kerolasa@iki.fi>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Sami Kerola <kerolasa@iki.fi>
Subject: [PATCH] Documentation/networking/ip-sysctl.txt tcp_tw_recycle & tcp_tw_reuse
Date: Mon,  4 Oct 2010 19:32:04 +0200
Message-Id: <1286213524-4659-1-git-send-email-kerolasa@iki.fi>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Kerola <kerolasa@iki.fi>

Instead of saying 'consult your technical export' the
documentation needs to assist an export to decide whether to keep
these settings off or set them on.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 Documentation/networking/ip-sysctl.txt |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index f350c69..01e2948 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -444,15 +444,21 @@ tcp_tso_win_divisor - INTEGER
 	Default: 3
 
 tcp_tw_recycle - BOOLEAN
-	Enable fast recycling TIME-WAIT sockets. Default value is 0.
-	It should not be changed without advice/request of technical
-	experts.
+	Enable fast recycling TIME-WAIT sockets. See also caution
+	wrote to tcp_tw_reuse. Default value is 0.
 
 tcp_tw_reuse - BOOLEAN
-	Allow to reuse TIME-WAIT sockets for new connections when it is
-	safe from protocol viewpoint. Default value is 0.
-	It should not be changed without advice/request of technical
-	experts.
+	Allow to reuse TIME-WAIT sockets for new connections when it is safe
+	from protocol viewpoint. One should enable also tcp_timestamps when
+	this is enabled. Default value is 0.
+
+	Caution. Both tcp_tw_recycle and tcp_tw_reuse can cause problems. You
+	should not enable either without being sure about network topology in
+	between node(s) which are using, or used by, the node(s) where the
+	parameter is enabled. Connections that go via TCP state aware nodes,
+	such as firewalls, NAT devices or load balancers may start drop frames
+	because of the setting. The more there are connections the greater is
+	the likelyhood you will see this issue.
 
 tcp_window_scaling - BOOLEAN
 	Enable window scaling as defined in RFC1323.
-- 
1.7.3.1

