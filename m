Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab1CXQ3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:29:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:38113 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1CXQ3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:29:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="901341900"
From: "Hebenstreit, Michael" <michael.hebenstreit@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Mar 2011 09:29:51 -0700
Subject: Patchwork [084/115] x86, mm: avoid possible bogus tlb entries by
 clearing prev mm_cpumask after switching mm - additional question
Thread-Topic: Patchwork [084/115] x86, mm: avoid possible bogus tlb entries
 by clearing prev mm_cpumask after switching mm - additional question
Thread-Index: AcvqQLNWO3fkP8OaTU+T3ghF6sCFCQ==
Message-ID: <6AF28EB9F93A354894F2F3916DF6F96E0D540428BD@orsmsx510.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha described in https://patchwork.kernel.org/patch/564801/ a TLB related problem: "Clearing the cpu in prev's mm_cpumask early will avoid the flush tlb IPI's while the cr3 is still pointing to the prev mm.  And this window can lead to the possibility of bogus TLB fills resulting in strange failures."

I was wondering if an error we saw with Lustre described in 

https://bugzilla.redhat.com/show_bug.cgi?id=678175
and
http://jira.whamcloud.com/browse/LU-93
 
could be attributed to the TLB problem described in 564801? The essence is that during massive parallel I/O sometimes page->private (which is used by Lustre as a pointer to private data) would be set to 2. The only place I found where this could happen OUTSIDE normal Lustre code is free_hot_page (called by page_cache_release). But the page remained in the cache, and when a later readpage() was issued, this lead a NULL pointer kernel panic. 

Architecture is x86_64, RH6 kernel 2.6.32-71.18.1.el6

thanks for any help
Michael

------------------------------------------------------------------------
Michael Hebenstreit                 Senior Cluster Architect
Intel Corporation                   Software and Services Group/HTE
2800 N Center Dr, DP3-307           Tel.:   +1 253 371 3144
WA 98327, DuPont           
UNITED STATES                       E-mail: michael.hebenstreit@intel.com
