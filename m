Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2IHPHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:07:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57083 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab2IHPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:07:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: irina.tirdea@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf tool: basename cleanups
Date: Sat,  8 Sep 2012 09:06:49 -0600
Message-Id: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

basename can modify strings passed to it, so the strings should not
be marked const. Clean up the offenders and remove the BIONIC wrapper
for libgen.h

Irina: Would you verify perf still compiles cleanly for Android. Thanks.

David Ahern (3):
  perf annotate: make a copy of filename for passing to basename
  perf probe: make a copy of exec path for passing to basename
  perf tool: remove BIONIC wrapper around libgen.h

 tools/perf/util/annotate.c    |    9 ++++++++-
 tools/perf/util/probe-event.c |   12 ++++++++++--
 tools/perf/util/symbol.h      |    2 --
 3 files changed, 18 insertions(+), 5 deletions(-)

-- 
1.7.10.1

