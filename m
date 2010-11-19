Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0KSQjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:39:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52526 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0KSQi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UGExl26XZ1vXgCHmvnMrtkLJXSZ6/XrWgWlUdN2+LreBHzrcQwXQX3onGmHB+E5u0E
         jtBvoPLYox9IVx0im1++qlED5kgE1ruoVvS0g6F0ey6em1S0gvHgViX6yI4eDa8cII5g
         pTs463SLtw8wzq05SmpEhkj8bnF9VOSxktIbQ=
MIME-Version: 1.0
In-Reply-To: <4CE6A69F.4030008@kernel.org>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<20101106053204.GB12449@count0.beaverton.ibm.com>
	<20101106204008.GA31077@sundance.ccs.neu.edu>
	<4CD5D99A.8000402@cs.columbia.edu>
	<20101107184927.GF31077@sundance.ccs.neu.edu>
	<4CD72150.9070705@cs.columbia.edu>
	<4CE3C334.9080401@kernel.org>
	<20101117153902.GA1155@hallyn.com>
	<4CE3F8D1.10003@kernel.org>
	<20101119041045.GC24031@hallyn.com>
	<4CE683E1.6010500@kernel.org>
	<04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
	<4CE698C5.5060806@kernel.org>
	<AANLkTikRHuaCpaROtty6X_Oe6JixzgcbVsxHxvtsu+UV@mail.gmail.com>
	<4CE6A076.2020807@kernel.org>
	<AANLkTikz++4_SvqU_Wvx5CjcpKJhPsD7q470swdqwn94@mail.gmail.com>
	<4CE6A397.6010105@kernel.org>
	<AANLkTin7kd3crS+fTLLea5PhAii7B3dz=n7p7YtQ6d4g@mail.gmail.com>
	<4CE6A69F.4030008@kernel.org>
Date: Fri, 19 Nov 2010 18:38:55 +0200
Message-ID: <AANLkTim-M02Z1igZ4LyXH_Qgyzx1iD0ZQkRT6dxcSE3P@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kirill Korotaev <dev@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 6:32 PM, Tejun Heo <tj@kernel.org> wrote:
> On 11/19/2010 05:27 PM, Alexey Dobriyan wrote:
>> On Fri, Nov 19, 2010 at 6:19 PM, Tejun Heo <tj@kernel.org> wrote:
>>>> The paragon of absurdity is struct task_struct::did_exec .
>>>
>>> Yeah, then go and figure how to do that in a way which would be useful
>>> for other purposes too instead of trying to shove the whole
>>> checkpointer inside the kernel.  It sure would be harder but hey
>>> that's the way it is.
>>
>> System call for one bit? This is ridiculous.
>
> Why not just a flag in proc entry?  It's a frigging single bit.

Because /proc/*/did_exec useless to anyone but C/R (even for reading!).

Because code is much simpler:

    tsk->did_exec = !!tsk_img->did_exec;
+
    __u8 did_exec;
