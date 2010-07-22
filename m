Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0GVMYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:24:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51370 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab0GVMYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:24:10 -0400
Message-ID: <4C48385C.9040309@zytor.com>
Date: Thu, 22 Jul 2010 05:23:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com> <1279731838-1522-3-git-send-email-robert.richter@amd.com> <4C476236.1020302@zytor.com> <1279747225.2812.37.camel@sbs-t61.sc.intel.com> <4C476C5B.8020604@zytor.com> <20100722121522.GT26154@erda.amd.com>
In-Reply-To: <20100722121522.GT26154@erda.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 05:15 AM, Robert Richter wrote:
> 
> Just wondering why you are using this_func()? Instead, you could
> simply do:
> 
> 	next_func();
> 	next_func = xstate_enable;
> 
> Do you see races when bringing up multiple cpus in parallel?
> 

It allows the compiler to turn it into a tailcall if frame pointers are
disabled.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

