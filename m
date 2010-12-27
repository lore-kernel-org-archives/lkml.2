Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0L0KwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:52:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60964 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0L0KwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=by2c3EY6xsKCqjb+u+ezN+/rliV7ad19XtTGOqw9KH6TxQbFTxcNU5UizHOQ/r3dmM
         KJ3Hg6Yp/5W3zZQlQQQZDIThr8G7KvaKkLzxKCwb2Tk1xgl3tkB2r/ZZrdHFUIi5wMMI
         VXQu32LuwemeI8zxRIi8aelpNaSQZLxm22bXM=
Date: Mon, 27 Dec 2010 11:52:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20101227105203.GE11419@htj.dyndns.org>
References: <20101214174900.058235985@linux.com>
 <4D0CC982.3030905@kernel.org>
 <alpine.DEB.2.00.1012211634560.3769@router.home>
 <4D11373D.9010205@zytor.com>
 <20101222091358.GC27861@htj.dyndns.org>
 <alpine.DEB.2.00.1012231812280.22549@router.home>
 <4D13E7D5.7020503@zytor.com>
 <alpine.DEB.2.00.1012242251090.23107@router.home>
 <AANLkTikSwwMtDwx4wGM8hO4riZFVmtkq_bihVvPirO8F@mail.gmail.com>
 <alpine.DEB.2.00.1012251753530.8506@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012251753530.8506@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 05:55:22PM -0600, Christoph Lameter wrote:
> On Sat, 25 Dec 2010, Tejun Heo wrote:
> 
> > ABI.  But that said, it might still be problematic on other
> > architectures when we try to apply it to different architectures.  Is
> > everyone against just taking a scalar for the first variable instead
> > of taking a pointer?  I'd be happier with that than the current one.
> 
> How about replacing that with two scalars? Macro will check that the
> scalaers are properly aligned and that the second follows the first. Then
> there is also better symmetry in the parameters.
> 
> bool this_cpu_cmpxchg_double(
>           percpu_1, percpu_2
>           old_1, old_2
>           new_1, new_2
> )

Yeah, maybe.  The interface is a bit redundant but probably the most
fool proof.  I'm okay with either taking a single scalar or both.

Thanks.

-- 
tejun
