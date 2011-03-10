Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1CJOrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:47:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1CJOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:47:32 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=e5lWYqgyaTkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ppOZOU4fZGbLSAo-6RIA:9 a=Puxgh-_wlzbSumXJICXDjs3sNAIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] trace-cmd: correct cpu list parsing
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D78A0A6.2060009@cn.fujitsu.com>
References: <4D78A0A6.2060009@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 09:47:30 -0500
Message-ID: <1299768450.15854.337.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:57 +0800, Lai Jiangshan wrote:
> Old parsing code is incorrect, when we use execute
> ./trace-cmd report --cpu 1,2-4,6,9-13
> 
> the result of filter_cpus will be:
> 1,2,1,2,3,4,6,9,5,6,7,8,9,10,11,12,13
> 
> The correct filter_cpus should be:
> 1,2,3,4,6,9,10,11,12,13,
> 
> I can change about 10 existed lines to make it correct, but it will be
> still bad readability, so I port the neat and good readability code:
> linux_kernel_src/lib/bitmap.c:bitmap_parselist()
> to here and replace the origin code

Yeah that code never got much love. I added it as a hack as the first
filter to use. And never really spent much time in fixing it. As it
goes, "if it works for what I need it for, it's good enough" ;)

-- Steve


