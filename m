Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2KPXUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:20:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:18555 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2KPXUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:20:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="248474229"
Message-ID: <50A6CA24.9020809@intel.com>
Date: Fri, 16 Nov 2012 15:20:04 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de, mingo@redhat.com,
        andi@firstfloor.org, Frederic Weisbecker <fweisbec@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on
 C visible symbols
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>  <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>  <1353104456.7586.27.camel@gandalf.local.home>  <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com> <1353105926.7586.30.camel@gandalf.local.home> <50A6C6DB.2000205@zytor.com>
In-Reply-To: <50A6C6DB.2000205@zytor.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 03:06 PM, H. Peter Anvin wrote:
> On 11/16/2012 02:45 PM, Steven Rostedt wrote:
>>
>> #define __pa(x)        __phys_addr((unsigned long)(x))
>> #define __pa_symbol(x)    __pa(__phys_reloc_hide((unsigned long)(x)))
>>
>> I'm confused. __pa_symbol() just calls __pa() with some macro magic to
>> its parameter. How is this a performance improvement?
>>
>
> One of the earlier patches in this series changes __pa_symbol() to
> avoid the conditional hidden inside __phys_addr(), since by definition
> a symbol can only be on one side of that branch.
>
>     -hpa
>

In addition to being a bit faster the code is also a bit smaller since
it can combine the the constants from __va() and __pa_symbol() as the
new __pa_symbol is an inline in the non-debug case.

Thanks,

Alex
