Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1BUKsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:48:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1BUKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ao6fYU9yoCHHQBxFpG8FWg35D6qZKo6zB9LtrKtpfT6SQv0mBebeY7DADkzLcf2n3V
         Lzypc/xXPaQxhxVT67+odYvJWICux1vzlwttfwNlbHD6JtPHICOi6sI4N/qVGNnmQuvU
         0mKR3Sem+5wE9bWs5gTqa6bxfUkJ4QlQ5phso=
Date: Mon, 21 Feb 2011 11:48:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 4/4] x86, numa: seperate alloc_numa_distance from
 numa_reset_distance.
Message-ID: <20110221104803.GK31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC19A.9030808@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5EC19A.9030808@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 18, 2011 at 10:59:38AM -0800, Yinghai Lu wrote:
> +	if (!numa_distance)
> +		alloc_numa_distance();
> +
> +	if (!numa_distance_cnt)
> +		return;

Can you at least make alloc_numa_distance() return -ENOMEM on failure
instead of checking the numa_distance_cnt implicitly in the caller?

Thanks.

-- 
tejun
