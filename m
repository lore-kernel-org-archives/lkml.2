Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1AFDtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:49:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33662 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1AFDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R0+j77qEQ2iZv8TOgiY4ZKeGo86a6R/qFW7rqdqjDS/Otf2Dx0856q/RyW6+eLxexW
         SJCTV0JYZGrnH7TiUFhhXIK6Qk4xWXwcQWoVig4eMFQbePP2wFoXizyYV/cu0HF2n72r
         VGBcncY7tnTM6zvkebmxZuTLz3+xxpvijN4vQ=
Date: Wed, 5 Jan 2011 19:49:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
Message-ID: <20110106034940.GC19416@mtj.dyndns.org>
References: <20110103162637.29f23c40@annuminas.surriel.com>
 <20110103162918.577a9620@annuminas.surriel.com>
 <1294164289.2016.186.camel@laptop>
 <4D24A5F4.3000508@redhat.com>
 <1294247718.2016.269.camel@laptop>
 <4D24A822.4000009@redhat.com>
 <1294248511.2016.274.camel@laptop>
 <4D24ABD7.4040503@redhat.com>
 <1294249159.2016.275.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294249159.2016.275.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 05, 2011 at 06:39:19PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-05 at 19:35 +0200, Avi Kivity wrote:
> 
> > Tejun, why did you end up not using preempt_notifiers in cmwq?
> 
> Because I told him to use explicit function calls because that keeps the
> code easier to read.

It went like the following.

* Beefing up preempt_notifier() results in too many different
  notifiers.  They better be unified.

* Unified notifiers are ugly (macro bonanza as expected) and cmwq
  hooks are always enabled unlike other notifiers.  Let's just keep it
  simple and specialized.

So, the cmwq stuff is now mostly hard coded into scheduler.  For cmwq,
everything is fine but it would still be great if the various
notifiers can be assimilated in prettier way.

Thanks.

-- 
tejun
