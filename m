Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1AaPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:53:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1AaPxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:53:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qlLmrWhdrTS3m1yIm6DKR+ZsZIB837gk4JmojSVA/qqA3GtUN/Md89t/cM8DOVzG0a
         fhMQFXHN91Ahoy406S06/dGSVgP/jLlhvEDKu51HAQwNKtjtLSzxdGyV0qtdVMGWlvxZ
         +7NrycGUODYwLM3Hx2BexmvscuxJQQ+CqPAKk=
Date: Mon, 31 Jan 2011 16:53:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, tglx@linutronix.de, rientjes@google.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/numa] x86: Unify cpu/apicid <-> NUMA node mapping
 between 32 and 64bit
Message-ID: <20110131155330.GL7459@htj.dyndns.org>
References: <1295789862-25482-14-git-send-email-tj@kernel.org>
 <tip-bbc9e2f452d9c4b166d1f9a78d941d80173312fe@git.kernel.org>
 <4D4327FC.5000600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4327FC.5000600@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Fri, Jan 28, 2011 at 12:33:00PM -0800, Yinghai Lu wrote:
> > +#ifdef CONFIG_NUMA
> > +extern int __cpuinit numa_cpu_node(int apicid);
> 
> cpu or apicid?

Should have been @cpu.  Will send a patch to update it.

> > +int __cpuinit numa_cpu_node(int cpu)
> > +{
> > +	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
> > +
> > +	if (apicid != BAD_APICID)
> > +		return __apicid_to_node[apicid];
> > +	return NUMA_NO_NODE;
> > +}
> 
> it should be changed to cpu_to_node_via_apicid(), it could return
> not onlined node, aka node without memory.
> 
> So don't mess it up with cpu_to_node()

Hmmm... are you saying that the name is too confusing with
cpu_to_node() and should be renamed to cpu_to_node_via_apicid()?  In
that case, I agree but wish the name were something which represents
what it does as _via_apicid postfix doesn't really tell much.  Any
better idea?

Thanks.

-- 
tejun
