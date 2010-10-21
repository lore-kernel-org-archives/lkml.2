Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0JUCxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0JUCxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:53:48 -0400
X-User-Agent: K-9 Mail for Android
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com> <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org> <20101021013833.GA21863@sli10-conroe.sh.intel.com>
In-Reply-To: <20101021013833.GA21863@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Oct 2010 19:53:17 -0700
To: Shaohua Li <shaohua.li@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Message-ID: <53a2d76e-2737-4e08-b408-2f939e2771e4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know, but I can't do that immediately.  It is an optimizatiin we can do for .38.

"Shaohua Li" <shaohua.li@intel.com> wrote:

>Hi hpa,
>On Thu, Oct 21, 2010 at 07:06:59AM +0800, tip-bot for Shaohua Li wrote:
>> [ hpa: moved it *after* the page-aligned section, for obvious
>>   reasons. ]
>move it after page-aligned section can't guarantee to avoid cache false
>sharing.
>we need:
>. = ALIGN(CACHE_LINE_SIZE);
>*(.data..percpu..readmostly)
>. = ALIGN(CACHE_LINE_SIZE);
>To make sure before/after readmostly section doesn't share cache line
>with
>others. The headcache is some arch need L1_CACHE_SIZE and others need
>(1 << INTERNODE_CACHE_SHIFT). We need change all ARCHs to make this
>happen.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
