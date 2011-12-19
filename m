Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1LSNkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:40:32 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24372 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab1LSNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:40:28 -0500
From: Nelson Elhage <nelhage@nelhage.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf: builtin-record: Be more helpful when running up against mlock limits.
Date: Mon, 19 Dec 2011 08:39:29 -0500
Message-Id: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
X-Mailer: git-send-email 1.7.4.41.g50b8f
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4EEF3EA3.0092,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current code, it's relatively easy to run up against the
perf_event_mlock_kb limit if you try to attach to a multithreaded
target with 'perf record -p', because perf will attempt to mmap 512k
per target thread, and the default mlock limit is (512k + 1 page),
total.

Current, this results in a completely inscrutable
  Fatal: failed to mmap with 22 (Invalid argument)

We should perhaps automatically detect a better choice of mmap_pages,
but in the meanwhile, it's easy to improve the error to give users
some guidance about what's going on, so that hopefully I can be the
last person to have to source-dive to figure out what's going on.

