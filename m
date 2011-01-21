Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1AUPsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:48:39 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49301 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1AUPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oIt7UKxAiSSChrr9eICG9fyHyYr1p6pmG8qyZx/ftUoTf7gvtaTDbMcOqRsuFD3+BV
         kJm7p84fRnfodNRuwSMlr5oMwWyMhOt2Zsrhx0zRr0DhRWbSMpILbooWYaqZyDPLqcFR
         e8eGINdEAjN3upIr96+sbjRZ8HgGL//WceQ3E=
Date: Fri, 21 Jan 2011 16:48:31 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110121154831.GE2832@htj.dyndns.org>
References: <20110106204513.669098445@linux.com>
 <20110106204525.222395863@linux.com>
 <4D263C91.30709@zytor.com>
 <alpine.DEB.2.00.1101070907060.3014@router.home>
 <20110107180419.GB23082@Krystal>
 <alpine.DEB.2.00.1101071227450.3014@router.home>
 <20110108172453.GF13269@mtj.dyndns.org>
 <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org>
 <4D39A6EB.70705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D39A6EB.70705@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Jan 21, 2011 at 07:31:55AM -0800, H. Peter Anvin wrote:
> I really object to passing two pointers where one of them has to be a
> fixed offset to the other.  That really doesn't make any sense.

Yeah, I hear you, but it really comes down to which ugliness disgusts
one the most.  That, unfortunately, is inherently very subjective when
there's no significantly better choice.

For me, the double parameter thing at least seems to have the
advantages of being able to verify the two intended memory locations
to be used actually are together and looking ugly reflecting its true
nature.

The inherent ugliness stems from the fact that we don't have the
built-in data type to properly deal with this.  Array of length two
might be better fit, but I can see as many downsides with that too.

So, if anyone can give something clearly better for technical reasons,
I'll be more than happy to take it, but as it currently stands, it
seems we'll have to choose one among uglies and not everyone would be
happy about the choice.  :-(

Thanks.

-- 
tejun
