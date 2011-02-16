Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1BPXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:03:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38774 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1BPXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YX9VFSQGodA4Xg1R2tFMcBzk1hwRdJsmXPYw0uQ+ZHzWh2aP6aBkG9CDN7mjvO9iRw
         8CHO4uuBOZALTRqXwr02Ev5CXOwH4Nvt7gt1i+4fQG/7OuwkQrnSYM/xHnPvtvcaymrn
         AiP9W5uqSkbj06fV69cStW3mae939CY18hUao=
Date: Thu, 17 Feb 2011 00:03:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: refactoring numa_register_memblks
Message-ID: <20110216230340.GF29600@atj.dyndns.org>
References: <4D5C3A0F.3080107@kernel.org>
 <4D5C3A81.4070408@kernel.org>
 <20110216224322.GB29600@atj.dyndns.org>
 <4D5C554E.7050701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C554E.7050701@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 02:53:02PM -0800, Yinghai Lu wrote:
> > Sorry, nack.  This squarely falls in the realm of bikeshedding and I
> > plan on collapsing init_memory_mapping_high() into the register
> > function.
> 
> no. init_memory_mapping_high now it is with early_node_map[], aka it
> is e820 and srat table overlapping one.

Hmmm... okay, I'll think more about it but currently it looks silly.
It isn't necessary for !NUMA and is done in rather convoluted way in
NUMA.  The name is misleading too.  There's nothing like mapped high
memory.  Maybe it would be better to use suffix like _above_4g.  At
any rate, I don't really see the point of moving those functions
calls.

The way I see it is that these things are inherently subjective.  When
you're writing or updating the part, it's natural to follow your own
preference.  When reviewing or working on other's code, trying to
enforce all those subjective details doesn't really help anyone.  Push
the ones with technical advantages; otherwise, just let it go.

Thanks.

--
tejun
