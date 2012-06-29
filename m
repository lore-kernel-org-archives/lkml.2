Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2F2Pmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:42:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2F2Pmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:42:39 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=eVEpPJsPTu0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=gu6fZOg2AAAA:8 a=9K0_nV6UrAJ200Q4cxsA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340984558.16702.129.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Optimize if statement logic where newline exists
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 29 Jun 2012 11:42:38 -0400
In-Reply-To: <1340984411.16702.127.camel@gandalf.stny.rr.com>
References: <1340984411.16702.127.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 11:40 -0400, Steven Rostedt wrote:
> In reviewing Kay's fix up patch: "printk: Have printk() never buffer its
> data", I found two if statements that could be combined and optimized.
> 
> Put together the two 'cont.len && cont.owner == current' if statements
> into a single one, and check if we need to call cont_add(). This also
> removes the unneeded double cont_flush() calls.
> 
> Link: http://lkml.kernel.org/r/1340869133.876.10.camel@mop
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
> [ This patch is dependent on Kay's patch, referenced at the above Link ]
> 

As the above link seems to time out, here's a more direct one:


http://marc.info/?l=linux-kernel&m=134084777330388

-- Steve

