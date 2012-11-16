Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2KPXad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:30:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28051 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2KPXac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:30:32 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Xsuh4gBeN78A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=DsRlZD7jQlIA:10 a=aOjwQsHjNRyf2ciP04YA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353108630.7586.31.camel@gandalf.local.home>
Subject: Re: [PATCH v4 6/8] x86/ftrace: Use __pa_symbol instead of __pa on C
 visible symbols
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, andi@firstfloor.org,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 18:30:30 -0500
In-Reply-To: <50A6C6DB.2000205@zytor.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
	  <20121116215718.8521.24026.stgit@ahduyck-cp1.jf.intel.com>
	  <1353104456.7586.27.camel@gandalf.local.home>
	  <a162a888-9892-43ca-ad17-61c19936c6f4@email.android.com>
	 <1353105926.7586.30.camel@gandalf.local.home> <50A6C6DB.2000205@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 15:06 -0800, H. Peter Anvin wrote:
> On 11/16/2012 02:45 PM, Steven Rostedt wrote:
> >
> > #define __pa(x)		__phys_addr((unsigned long)(x))
> > #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
> >
> > I'm confused. __pa_symbol() just calls __pa() with some macro magic to
> > its parameter. How is this a performance improvement?
> >
> 
> One of the earlier patches in this series changes __pa_symbol() to avoid 
> the conditional hidden inside __phys_addr(), since by definition a 
> symbol can only be on one side of that branch.
> 

Ah I missed the 6/8 reference and haven't looked at the rest of the
series.

OK, this makes sense now.

-- Steve


