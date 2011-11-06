Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1KFN06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:26:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41010 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1KFN05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:26:57 -0500
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] use kstrtoul, etc
Date: Sun,  6 Nov 2011 14:26:45 +0100
Message-Id: <1320586010-21931-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches replace calls to strict_strtoul, etc by the corresponding
calls to kstrtoul.  The complete semantic patch that makes these changes is
as follows.  This semantic patch checks that the types are as expected,
which was always the case for these files.

// <smpl>
@@
expression a,b;
{int,long} *c;
@@

-strict_strtol
+kstrtol
 (a,b,c)

@@
expression a,b;
long long *c;
@@

-strict_strtoll
+kstrtoll
 (a,b,c)

@@
typedef ulong;
expression a,b;
{ulong,unsigned long,unsigned int,size_t} *c;
@@

-strict_strtoul
+kstrtoul
 (a,b,c)

@@
expression a,b;
unsigned long long *c;
@@

-strict_strtoull
+kstrtoull
 (a,b,c)

@@
expression a,b;
u64 *c;
@@

-strict_strtoull
+kstrtou64
 (a,b,c)

@@
@@

(
+BAD(
  strict_strtoull(...)
+)
|
+BAD(
  strict_strtoul(...)
+)
|
+BAD(
  strict_strtol(...)
+)
|
+BAD(
  strict_strtoll(...)
+)
)
// </smpl>

