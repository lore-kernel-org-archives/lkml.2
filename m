Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2BVHgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:36:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2BVHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:36:05 -0500
Message-ID: <4F449ACF.3040807@zytor.com>
Date: Tue, 21 Feb 2012 23:35:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu>
In-Reply-To: <20120222072538.GA17291@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:25 PM, Ingo Molnar wrote:
> 
> There is a fundamental assymetry, and intentionally so. You 
> *really* have to think what the common case is, and make sure 
> the build defaults to that. It's not the end of the world to 
> have it flipped over, but there's costs and those costs are 
> higher even in the branch path than a regular 
> likely()/unlikely().
> 

No, not really -- it's still an unconditional branch, which means you
will not tax the branch predictor in any way and which can be followed
by the front end without taking a speculation hit.  So although there is
an out-of-line penalty -- which you hit for any conditional, after all
you can only have *one* piece of code which is straight line -- it
should be less than for a normal conditional branch.

> So you are rather wrong about your expectations - I think that 
> is one more piece of evidence that the naming was less than 
> optimal.
> 
>> So the key aspect of this is the staticness of the 
>> conditional, NOT the degree of bias of the branch.  Hence my 
>> past insistence on the "static_branch" name (rather than 
>> "jump_label")... the branch part can be omitted, as an 
>> implementation detail, but the staticness of it is its 
>> absolutely key defining characteristic.
> 
> I don't think you understand this facility as well as you think 
> you do.

Uh, no, I do... see the above, but combine that of course with the sheer
astronomical cost of flipping the conditional.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

