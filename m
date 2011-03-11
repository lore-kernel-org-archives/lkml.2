Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1CKMHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:07:32 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47570 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CKMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xlso7OtQRMnIMkWUbR7zh4Tqd4B3ygibhkvq4YbRV32Za6NIMpsJLMwSsV3XJE7gF7
         wjhA9H+zlfIV+gWLbdG0PmBMu2lKvo1CSnXFe/m012K8IOtb6FEfbkZPzjBy22CysGYu
         W/B9lTRO+zONhmKnsnjlMvan+DDnNO88tOJuA=
Date: Fri, 11 Mar 2011 13:07:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110311120723.GC1826@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
 <20110307180619.GG1873@nowhere>
 <AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
 <20110310024355.GG2533@nowhere>
 <AANLkTikZxDyL-SW7FFbEd4skMNTVWeh7mGDTXfWkvEMR@mail.gmail.com>
 <20110311115657.GB1826@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311115657.GB1826@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 12:57:01PM +0100, Frederic Weisbecker wrote:
> On Thu, Mar 10, 2011 at 10:32:43PM +0800, Sam Liao wrote:
> >  the sysprof that Ingo mentioned.
> 
> sysprof does something like that?
> 
> Note, another reason to avoid abusing the event.ip to group
> per caller, is that we could be able to:
> 
> perf report -s caller,sym -g caller
> 
> If we limit callchains to start from a given foo.so, this may
> sort hists per caller and then per endpoint.
> 
> If your library offers function func1, func2, etc... It will sort
> them per usage (func1 has been first used, then func2, etc...)

I meant func1 has been the most used, then came func2, etc...

> then per endpoint overhead (func1 most often sticks in strcpy(),
> then on read(), etc....).
> 
> Right?
> 
> That may or may not be useful. I don't know. In fact I don't
> want to take the responsibility to judge whether it's useful
> or not. Thus I prefer caller and ip to be two different
> properties of hist entries and not having one absusing the
> other, so that we don't prevent this feature to exist (or many
> other sort combinations I haven't imagined).
