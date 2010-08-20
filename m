Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0HTUqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:46:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47118 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0HTUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bIuIemp0Gxhx2GCVDhMf7isYTHaO0sv7IqKnIgZxq6zej+8ptZnnhfxVD5ZQ+X7pxu
         cMidML1/BkwH5OrSdJA5LZnRvpyozOrSCDzf6lVBQ79bvxyjtd6m//tKz0TgYQ3s26iZ
         DXTRIzICSH/03OxcZI5Rxm6z6IYdYm+aFTL8M=
Date: Sat, 21 Aug 2010 00:45:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100820204558.GA15530@lenovo>
References: <1282214753.1926.4669.camel@laptop> <20100819141240.GO4879@redhat.com> <1282228033.2605.204.camel@laptop> <20100820015017.GA4879@redhat.com> <20100820081605.GD17551@elte.hu> <1282298651.2605.769.camel@laptop> <20100820123901.GE4879@redhat.com> <20100820132737.GD3321@elte.hu> <20100820135118.GI4879@redhat.com> <20100820141703.GA29697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820141703.GA29697@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:17:03PM +0200, Ingo Molnar wrote:
> 
> it's not working so well, i'm getting:
> 
>  Uhhuh. NMI received for unknown reason 00 on CPU 9.
>  Do you have a strange power saving mode enabled?
>  Dazed and confused, but trying to continue
> 
> on a nehalem box, after a perf top and perf stat run.
> 
> Thanks,
> 
> 	Ingo
> 

Might not this be the case of AAN93 erratum, which says the following

 | The processor can be configured to issue a PMI (performance monitor interrupt)
 | upon overflow of the IA32_FIXED_CTR0 MSR (309H). A single PMI should be observed on
 | overflow of IA32_FIXED_CTR0, however multiple PMIs are observed when this
 | erratum occurs.

Just a thought.

	-- Cyrill
