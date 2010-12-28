Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0L1LNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:13:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0L1LNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:13:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bGQQArclUNW6Fev4fkcOjZuam5zg+QeG0Q7bsrxs50czKOpb+8kyUM0LvFHvjxhAMy
         2PiwkaWZDvGqyw7xXEEwhcITCpYDLeFyggd1kC2B3kLfSb0zo86/Pkn2+Bo2mlDTOd2K
         X0ddKKCRiy0unSg7Ci+jKKWsX7vka51Xf9XN0=
Date: Tue, 28 Dec 2010 12:13:32 +0100
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
Message-ID: <20101228111332.GE488@htj.dyndns.org>
References: <4D08CBF4.6040102@gmail.com>
 <1292460817.2323.465.camel@sli10-conroe>
 <20101216054620.GA3241@merkur.ravnborg.org>
 <1292479000.2323.468.camel@sli10-conroe>
 <4D09E0EE.7040605@gmail.com>
 <1292808518.10593.8.camel@sli10-conroe>
 <4D0F7C5A.1060107@gmail.com>
 <1293071914.10593.10.camel@sli10-conroe>
 <20101227121454.GB488@htj.dyndns.org>
 <1293496017.10593.26.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293496017.10593.26.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 28, 2010 at 08:26:57AM +0800, Shaohua Li wrote:
> Subject: make readmostly section correctly align
> 
> readmostly section should end at cache line aligned address, otherwise the last
> several data might share cachline with other data and make the readmostly data
> still have cache bounce.
> For example, in ia64, secpath_cachep is the last readmostly data, and it shares
> cacheline with init_uts_ns.
> a000000100e80480 d secpath_cachep
> a000000100e80488 D init_uts_ns
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Yeap, this looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

I can route this through percpu tree but think -mm is the better fit.
Andrew, can you please take this one?

Thank you.

-- 
tejun
