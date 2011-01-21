Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1AURLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:11:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1AURLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aNjaVmh3Mtb53J6PnWtUMgPqneIMsuSMSY7fuVCC27Mh65y4L4X/4DKTyFPuB4JXox
         WAooakUXivel5r1xM6d4eX8Uz6MfZSfNH1xzxv3wJEZNLQm6+2t9kXW3Y6m5LV8OZqqu
         i+8YUeOKXH9eZ2rEOtY5gHZcgleJaW4mbe4d4=
Date: Fri, 21 Jan 2011 18:11:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
Message-ID: <20110121171133.GI2832@htj.dyndns.org>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012151404070.21102@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

I was trying to forward this to x86 tree but spotted a problem.

On Wed, Dec 15, 2010 at 02:07:39PM -0600, Christoph Lameter wrote:
> +static __always_inline int this_cpu_constant_test_bit(unsigned int nr,
> +                        const unsigned long __percpu *addr)
> +{
> +	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
> +
> +	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read_stable(*a)) != 0;
> +}

I don't think percpu_read_stable() can be used here.  It's not
guaranteed to be stable across different cpus.

Also, can we just implement what's necessary on top of this_cpu_has()?
this_cpu_has() already has constant handling, so there's no need to
add this_cpu_test_bit() at this point.

Thank you.

-- 
tejun
