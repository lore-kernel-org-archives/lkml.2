Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab0L0VGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:06:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54010 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab0L0VGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:06:01 -0500
Message-ID: <4D18FF39.6080101@zytor.com>
Date: Mon, 27 Dec 2010 13:03:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Tejun Heo <tj@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH RESEND percpu#for-next] percpu: align percpu readmostly
 subsection to cacheline
References: <20101227133719.GD488@htj.dyndns.org> <20101227204309.GA3878@merkur.ravnborg.org>
In-Reply-To: <20101227204309.GA3878@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2010 12:43 PM, Sam Ravnborg wrote:
> 
> It would have been better to include cache.h and then use L1_CACHE_BYTES,
> as the value differs for EV4.
> It will work with 64 as this is the bigger of the two.
> 
> It looks like we could do this for almost all archs.
> But then I am not sure if "L1_CACHE_BYTES" is the same as
> a cacheline on the different archs.
> 

For x86, L1 is definitely not the right cache line to use, in terms of
what matters for SMP sharing.  And yes, there are x86's with smaller L1
than L2/3 cache line size.

	-hpa

