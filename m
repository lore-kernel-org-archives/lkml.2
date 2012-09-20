Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2ITNmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:42:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2ITNl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:41:57 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=WnYo-2BfFuEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-t9bLuw0o0EA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=c6qrIerQ8nX9AE4Fx_IA:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348148514.13080.61.camel@gandalf.local.home>
Subject: Re: [PATCH] trace: don't call page_to_pfn() if page is NULL
From: Steven Rostedt <rostedt@goodmis.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, khlebnikov@openvz.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date: Thu, 20 Sep 2012 09:41:54 -0400
In-Reply-To: <20120920062832.GG13234@bbox>
References: <505AB1FF.8020104@cn.fujitsu.com> <20120920062832.GG13234@bbox>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 15:28 +0900, Minchan Kim wrote:
> On Thu, Sep 20, 2012 at 02:04:47PM +0800, Wen Congyang wrote:
> > When allocating memory fails, page is NULL. page_to_pfn() will
> > cause the kernel panicked if we don't use sparsemem vmemmap.
> > 
> > Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> 
> Nice catch.
> I think it's a candidate of stable.

Yeah, and it looks like it can go against all stable kernels as it was
introduced back in 2.6.32. I'll apply and start testing it.

Thanks,

-- Steve

> 
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> 


