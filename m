Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1BQUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:55:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab1BQUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:55:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Tb9e5oAkxTDuhI05AaZdTNj41zwQ1rJFInyHy5t7cAeY4hSTcYXvwHVRMeT1CnK8C
	QMGbqi/Lwt5ATexBUONCw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH v3 0/2] memcg: variable type fixes
Date: Thu, 17 Feb 2011 12:52:46 -0800
Message-Id: <1297975968-19672-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since -v2:
- Reworded patch 1 commit message.

This is a two part series that is a cleanup of memcg internal
counters.  These two patches were originally proposed by Johannes
Weiner [1].  The original series was based on an older mmotm, so I had
to massage the patches a little.  The patches are based on
mmotm-2011-02-10-16-26.

Patch 1 implements the idea that memcg only has to use signed types
for some of the counters, but not for the constant monotonically
increasing event counters where the sign-bit is a waste.
Originally proposed in [2].

Patch 2 converts the memcg fundamental page statistics counters to
native words as they should be wide enough for the expected values.
Originally proposed in [3].

References:
 [1] https://lkml.org/lkml/2010/11/7/170
 [2] https://lkml.org/lkml/2010/11/7/174
 [3] https://lkml.org/lkml/2010/11/7/171

Johannes Weiner (2):
  memcg: break out event counters from other stats
  memcg: use native word page statistics counters

 mm/memcontrol.c |   78 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 27 deletions(-)

-- 
1.7.3.1

