Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1BWVDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:03:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39447 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1BWVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aHi+hhi3W9iQU6+FJPlJY2Qsm7h3nhn5ULO2oxVS3kTO4WhNXflEQIgAITUh1U+LQy
         qVXzJ8gLu7ys9w8M79K3nzVQgAHasnqGSD5xioEa/l837q6zeX2/85039P9gHevu6TtZ
         PZ8CvR/TUk0zQmmR2GNWCbhqRWQK4S+bMX3dQ=
Date: Wed, 23 Feb 2011 22:03:26 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
Message-ID: <20110223210326.GB27738@atj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D657359.5060901@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Feb 23, 2011 at 12:51:37PM -0800, Yinghai Lu wrote:
> On 02/23/2011 12:46 PM, Tejun Heo wrote:
> >> Intel CPU Nehalem-EX does not. and several vendors do provide 8 sockets
> >> NUMA system with 1024g and 2048g RAM
> > 
> > That's interesting.  Didn't expect that.  So, this one is an actually
> > valid reason for implementing per node mapping.  Is this Nehalem-EX
> > only thing?  Or is it applicable to all xeons upto now?
> 
> only have access for Nehalem-EX and Westmere-EX till now.

I see.  I was wondering whether it was a worthwhile optimization if it
was an one-off thing for Nehalem-EX.

> >>> 3. The new code creates linear mapping only for memory regions where
> >>>    e820 actually says there is memory as opposed to mapping from base
> >>>    to top.  Again, I'm not sure what the intention of this change was.
> >>>    Having larger mappings over holes is much cheaper than having to
> >>>    break down the mappings into smaller sized mappings around the
> >>>    holes both in terms of memory and run time overhead.  Why would we
> >>>    want to match the linear address mapping to the e820 map exactly?
> >>
> >> we don't need to map those holes if there is any.
> > 
> > Yeah, sure, my point was that not mapping those holes is likely to be
> > worse.  Wouldn't it be better to get low and high ends of the occupied
> > area and expand those to larger mapping size?  It's worse to match the
> > memory map exactly.  You unnecessarily end up with smaller mappings.
> 
> it will reuse previous not used entries in the init_memory_mapping().

Hmmm... I'm not really following.  Can you elaborate?  The reason why
smaller mapping is bad is because of increased TLB pressure.  What
does using the existing entries have to do with it?

Thanks.

--
tejun
