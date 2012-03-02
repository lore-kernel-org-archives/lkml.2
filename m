Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030434Ab2CBRrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:47:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:58275 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2CBRrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:47:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72865761"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 1/4] mce: Slim up struct mce
Thread-Topic: [PATCH 1/4] mce: Slim up struct mce
Thread-Index: AQHM+IBWFWKZbNJZNU6PTgaEVwa4kJZXRrQQ
Date: Fri, 2 Mar 2012 17:47:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F0410BD@ORSMSX104.amr.corp.intel.com>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-2-git-send-email-bp@amd64.org>
In-Reply-To: <1330698314-9863-2-git-send-email-bp@amd64.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Drop unused ->apicid, make ->socketid __u16 since it is copied from
> struct cpuinfo_86.phys_proc_id, reorder members and adjust padding so
> that it remains packed and on a 64-byte boundary.

This structure is user visible via /dev/mcelog.  The mcelog(8) daemon
has been coded to cope with extra fields being added to the end of the
structure (an old daemon that doesn't know what they are will just skip
over them). But things will break if you change the offsets of any fields
that it does know about.

Linus says - no breaking user space - so "NACK" for this patch.

-Tony
