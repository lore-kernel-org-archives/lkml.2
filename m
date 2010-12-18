Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0LROvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:51:40 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:43006 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0LROvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aMVxWL4scSINm8jbfAzgHQPQMo2MjTX0Dotxcva8dM2eaeVmFc/OZkoGMZ+IfxgRnQ
         wIkyO9GCz4fzpJNo7A+/eX76adZsOay5CXjK1APq4Bn5wBTea+xkWwsU+Iuua+PKXff6
         rZw8eqrinZey/DMZ6ni4ceuQSrV3wDMcy2whY=
Message-ID: <4D0CCA77.2040701@kernel.org>
Date: Sat, 18 Dec 2010 15:51:35 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org>
In-Reply-To: <4D0CC982.3030905@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 03:47 PM, Tejun Heo wrote:
> This is ugly. :-( I think we should have made this_cpu_*() ops take
> pointers from the beginning.  Anyways, that's too late, so is it
> completely impossible to make cmpxchg_double's take a scalar value?
> It can take the pointer all the same, no?

Also, the ratonale behind taking a scalar value instead of pointer was
that the operation changes what they do depending on the type of the
parameter (the size of the parameter), which is true for the double
ops too, so I think it would be better if we stick with lvalues.

Thanks.

-- 
tejun
