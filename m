Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2EKAxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:53:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:31255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2EKAxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142575098"
Message-ID: <4FAC62B9.9090304@intel.com>
Date: Fri, 11 May 2012 08:52:09 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user testing/tuning
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-8-git-send-email-alex.shi@intel.com> <20120510082731.GC30055@aftab.osrc.amd.com>
In-Reply-To: <20120510082731.GC30055@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +#ifdef CONFIG_DEBUG_TLBFLUSH

>> +static ssize_t __tlb_flushall_factor_store(const char *buf,
>> +					size_t count, int smt)
>> +{
>> +	short factor = 0;
>> +
>> +	if (sscanf(buf, "%hd", &factor) != 1)
>> +		return -EINVAL;
> 
> This means only single-digit factors, right?


No, you can try '32' '16' etc. not a 'single-digit'.

> 
> Why not use kstrtoul?


any advantage of this?

> 


