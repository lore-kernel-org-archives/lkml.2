Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1AXUE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:04:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1AXUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dEYu4Ue+4LxNVs3ufkCWbhQjD8tSp35VETQC6UsInVNK35HrLUHwyn7+2MJBPpryAB
         qd8WRxPGhiuQSJVAAob+GpN3JyBBehXh60W3fdZShkjPXQJK+YtR9ddK2fkt3VXFF3SR
         q9wgMfyftsEV5qdSCf4j2OF2emVSi50h7lJMU=
Date: Mon, 24 Jan 2011 21:04:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, eric.dumazet@gmail.com,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com, rientjes@google.com
Subject: Re: [PATCH 04/16] x86: Replace cpu_2_logical_apicid[] with early
 percpu variable
Message-ID: <20110124200448.GA22210@atj.dyndns.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
 <1295789862-25482-5-git-send-email-tj@kernel.org>
 <AANLkTimi0Q6mqD68H5WOf=grwuVXxMPKHgM7z6RcbhE1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimi0Q6mqD68H5WOf=grwuVXxMPKHgM7z6RcbhE1@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:58:24AM -0800, Yinghai Lu wrote:
> >  DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
> >  DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
> > +#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
> > +DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
> > +#endif
> 
> why changing it from u8 to int?

Because all other apic ids are int.  The phys ones are shared with
64bit, so they can't be u8.  I thought it would be more consistent
to have int for logicals too.

Thanks.

--
tejun

