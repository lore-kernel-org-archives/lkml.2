Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2CMHIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:08:11 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57396 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2CMHIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:08:07 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH -V3 0/8] memcg: Add memcg extension to control HugeTLB allocation
Date: Tue, 13 Mar 2012 12:37:04 +0530
Message-Id: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9
x-cbid: 12031307-8878-0000-0000-000001A2A6BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements a memory controller extension to control
HugeTLB allocations. The extension allows to limit the HugeTLB
usage per control group and enforces the controller limit during
page fault. Since HugeTLB doesn't support page reclaim, enforcing
the limit at page fault time implies that, the application will get
SIGBUS signal if it tries to access HugeTLB pages beyond its limit.
This requires the application to know beforehand how much HugeTLB
pages it would require for its use.

Changes from V2:
* Changed the implementation to limit the HugeTLB usage during page
  fault time. This simplifies the extension and keep it closer to
  memcg design. This also allows to support cgroup removal with less
  complexity. Only caveat is the application should ensure its HugeTLB
  usage doesn't cross the cgroup limit.

Changes from V1:
* Changed the implementation as a memcg extension. We still use
  the same logic to track the cgroup and range.

Changes from RFC post:
* Added support for HugeTLB cgroup hierarchy
* Added support for task migration
* Added documentation patch
* Other bug fixes

-aneesh


