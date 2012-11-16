Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2KPWp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:45:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2KPWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:45:27 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Xsuh4gBeN78A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=DsRlZD7jQlIA:10 a=AKVdPNEVw3gPT97Jzj4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353105926.7586.30.camel@gandalf.local.home>
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on C
 visible symbols
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, andi@firstfloor.org,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 17:45:26 -0500
In-Reply-To: <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
	 <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
	 <1353104456.7586.27.camel@gandalf.local.home>
	 <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 14:25 -0800, H. Peter Anvin wrote:
> It is a performance improvement.
> 
> >>  	 * kernel identity mapping to modify code.
> >>  	 */
> >>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> >> -		ip = (unsigned long)__va(__pa(ip));
> >> +		ip = (unsigned long)__va(__pa_symbol(ip));
> >>  
> >>  	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
> >>  }
> >> @@ -279,7 +279,7 @@ static int ftrace_write(unsigned long ip, const
> >char *val, int size)
> >>  	 * kernel identity mapping to modify code.
> >>  	 */
> >>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> >> -		ip = (unsigned long)__va(__pa(ip));
> >> +		ip = (unsigned long)__va(__pa_symbol(ip));
> >>  
> >>  	return probe_kernel_write((void *)ip, val, size);
> >>  }
> 

#define __pa(x)		__phys_addr((unsigned long)(x))
#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))


I'm confused. __pa_symbol() just calls __pa() with some macro magic to
its parameter. How is this a performance improvement?

-- Steve


