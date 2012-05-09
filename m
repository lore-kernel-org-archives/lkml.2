Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2EICME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 22:12:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:23939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2EICMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 22:12:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141675549"
Message-ID: <4FA9D21B.3040906@intel.com>
Date: Wed, 09 May 2012 10:10:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com> <4FA937C0.7080202@zytor.com>
In-Reply-To: <4FA937C0.7080202@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> This uses x86_model without qualifying it x86 (family), however that is
> meaningless.  All the CPUs you are dealing with above have c->x86 == 6,
> but you need to handle others correctly (even if that just means
> defaulting it to zero.)
> 
> One way to do that is to do:
> 
> switch ((c->x86 << 8) + c->x86_model) {
> 
> ... and use numbers like 0x62d instead of 45.


Yes, this is better, thanks!

> 
> 	-hpa
> 
> 


