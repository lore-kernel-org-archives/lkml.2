Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab0ETHED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:04:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0ETHEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d1mQCr6jENalJTvMlm+y/xQSmJYsSquSiaalhe/JsdZMZHK9qsGFkX3/DZbre5nYAf
         so98ZBRbFTHmZg+cKIbkwwo8A/h02HTo342nywqr3VLRxv+vA9t0hme6Touensc4pA4G
         WnoAlONUBnN5JlPT3cXRbtpoEK6/DvD+QnZFk=
Date: Thu, 20 May 2010 09:04:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100520070403.GB5309@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com> <20100513190325.GB5377@nowhere> <20100513194605.GG2879@linux.vnet.ibm.com> <20100513204855.GD5377@nowhere> <1273823225.5605.3604.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273823225.5605.3604.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:47:05AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 22:48 +0200, Frederic Weisbecker wrote:
> > +       head = find_swevent_head(cpuctx, event->attr.type,
> > +                                event->attr.config, event); 
> 
> might as well only pass event and have the function do those derefs.


Yeah, why not. But now that I see we can optimize the scheduling
side with rcu_dereference_protected, it's probably better to keep
the two derefs protected.

