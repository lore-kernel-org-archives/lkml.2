Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1AUR2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:28:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50370 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1AUR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:28:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dUNdzk3+gFM/PffhyhMkYQTfUwYNhwJm7Lxc1y945n0ahhhwu9XsjvrfGQ+Lanh2DC
         gTbcYZEhC8Spo5lGjdzSJN51P7XR535wShN/Inu5b+xRDpEXgF5UabYJbI8snSJ5+iOI
         4d2uOyZMhRrUjdkB1UCxowaOBouvz100FrePQ=
Date: Fri, 21 Jan 2011 18:28:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
Message-ID: <20110121172836.GK2832@htj.dyndns.org>
References: <alpine.DEB.2.00.1012151404070.21102@router.home>
 <20110121171133.GI2832@htj.dyndns.org>
 <alpine.DEB.2.00.1101211114530.15692@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101211114530.15692@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 11:21:02AM -0600, Christoph Lameter wrote:
> > I don't think percpu_read_stable() can be used here.  It's not
> > guaranteed to be stable across different cpus.
> 
> Why would that matter? The caller has to disabled preemption anyways since
> otherwise the processor may change which means that the result of the
> operation is useless.

Because

	preempt_disable();
	this_cpu_has();
	preempt_enable();
	preempt_disable();
	this_cpu_has();
	preempt_enable();

might malfunction.  percpu_read_stable() is pretty much applicable
only to stuff local to the thread.

> > Also, can we just implement what's necessary on top of this_cpu_has()?
> > this_cpu_has() already has constant handling, so there's no need to
> > add this_cpu_test_bit() at this point.
> 
> Not sure what you mean. this_cpu_test_bit is necessary because
> test_cpu_cap expects a regular pointer and performs a regular load.
> this_cpu_constant_test_bit handles the segment prefix necessary for a per
> cpu load.
> 
> The constant refers to the bit.

Oh, you're right.  Sorry about that.  Can you please then add a
comment noting that the operation is x86 only?  Maybe prefix it with
x86_?

Thanks.

-- 
tejun
