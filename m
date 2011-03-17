Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1CQCag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:30:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58648 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1CQCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:30:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D817234.9070106@jp.fujitsu.com>
Date: Thu, 17 Mar 2011 11:30:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] THP: page collapsing vs. poisoning
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set will improve system availability by allowing us to
avoid system panic in some special cases during page collapsing:
replacing a chunk of normal pages by a THP(Transparent Huge Page).

Hidetoshi Seto (4):
      Lock the new THP when collapsing pages
      Free the collapsed pages after the new THP is mapped.
      Check whether pages are poisoned before copying
      Check whether the new THP is poisoned before it is mapped to APL.

 mm/huge_memory.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 65 insertions(+), 10 deletions(-)


