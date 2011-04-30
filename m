Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1D3Mfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:35:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab1D3Mfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MmPzp341Bz3OHkeK3BbjUe3Um8/UEVtMUde4bGOhDCLNdaFrFaluNYzzi6/RDGV5QL
         09QYcAdPWVB/qwC4ZVzkp7h0BuODzHUM4YxuicHfwu39FwJkPO2kDpcjnc61QNnqmo1x
         HP3k0sUibBlT52Fe5nZonv9gk3B1mFDcpg/E0=
Date: Sat, 30 Apr 2011 14:35:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, NUMA: Fix empty memblk detection in
 numa_cleanup_meminfo()
Message-ID: <20110430123526.GH29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <4DBB1C16.3070307@kernel.org>
 <20110430121734.GF29280@htj.dyndns.org>
 <20110430123330.GG29280@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430123330.GG29280@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 02:33:30PM +0200, Tejun Heo wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> numa_cleanup_meminfo() trims each memblk between low (0) and high
> (max_pfn) limits and discard empty ones.  However, the emptiness
> detection incorrectly used equality test.  If the start of a memblk is
> higher than max_pfn, it is empty but fails the equality test and
> doesn't get discarded.
> 
> Fix it by using >= instead of ==.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> So, something like this.  Does this fix the problem you see?

Ooh, this is before the code is moved to numa.c, so please test the
previous patch against numa.c.

Thanks.

-- 
tejun
