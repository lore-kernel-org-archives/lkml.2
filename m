Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2EJHvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:51:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55953 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab2EJHui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:50:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 May 2012 16:49:06 +0900 (JST)
Message-Id: <20120510.164906.434297150.d.hatayama@jp.fujitsu.com>
To: ak@linux.intel.com
Cc: a.p.zijlstra@chello.nl, alex.shi@intel.com, mgorman@suse.de,
        npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] TLB flush optimization
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120509234512.GA27196@tassilo.jf.intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
	<1336489319.16236.43.camel@twins>
	<20120509234512.GA27196@tassilo.jf.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3] TLB flush optimization
Date: Wed, 9 May 2012 16:45:12 -0700

>> Have you tried what happens if you get rid of the funny multi-vector-ipi
>> scheme and use the generic smp_call functions?
> 
> Yes we did. It's much faster on larger systems.
> 
> But haven't sent the patch yet because wasn't sure if it wasn't slower
> on small systems.
> 
> -Andi

I'm not sure the reason of performance gain. I'm guessing that the
performance gain depends on waiting time of specific multi-vector-ipi
vs wasting time of generic code consumed for the processing actually
unnecessary for TLB flushing, and on small systems the specific one is
shorter than the generic one, and on large systems the converse
holds. Is this correct?

Thanks.
HATAYAMA, Daisuke

