Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1ELIWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:22:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42475 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1ELIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WSOroMwT/O73NWaUfRUDRdnMtygDW3I6toOXeBxMMewgH1UK5Qgi9ltGPaktQKyoek
         yIP7GBwxCNm8zZqrS5C+6tCFxMUL8jYfUlJ0Jsa8cmQ2mGxA1PwMIz6matsn8e+j6TxR
         cuwaAQ8qkDo7g7ktUIWhWJAH7fv0wXf9a5X3g=
Date: Thu, 12 May 2011 10:21:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
Message-ID: <20110512082159.GB1030@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
 <20110511092848.GE1661@htj.dyndns.org>
 <1305168493.2373.15.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305168493.2373.15.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 10:48:13AM +0800, Shaohua Li wrote:
> And the atomic64 approach not just improved the performance (which is
> always welcomed), but it also fixes a bug for 32-bit system. The usage
> of lglock is actually quite straightforward and is standard usage of
> lglock (the comments of lglock.h declare such usage), just lglock
> doesn't work for dynamatically allocated structure currently, which
> needs a convert.

lglock doesn't seem like the right solution for the problem at hand.
It's way too heavy handed and used to close a very small race window.
It doesn't seem right.  Eric's idea seemed much better to me and I
don't see why that can't be improved and used instead.  Would you be
interested in looking that direction?

Thanks.

-- 
tejun
