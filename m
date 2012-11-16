Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2KPXGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:06:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab2KPXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:06:20 -0500
Message-ID: <50A6C6DB.2000205@zytor.com>
Date: Fri, 16 Nov 2012 15:06:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, andi@firstfloor.org,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on
 C visible symbols
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>  <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>  <1353104456.7586.27.camel@gandalf.local.home>  <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com> <1353105926.7586.30.camel@gandalf.local.home>
In-Reply-To: <1353105926.7586.30.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 02:45 PM, Steven Rostedt wrote:
>
> #define __pa(x)		__phys_addr((unsigned long)(x))
> #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
>
> I'm confused. __pa_symbol() just calls __pa() with some macro magic to
> its parameter. How is this a performance improvement?
>

One of the earlier patches in this series changes __pa_symbol() to avoid 
the conditional hidden inside __phys_addr(), since by definition a 
symbol can only be on one side of that branch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

