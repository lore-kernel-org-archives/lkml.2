Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0DSOq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:46:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0DSOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:46:55 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BCC69D5.3050209@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>
	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>
	 <4BCC3A3E.9070909@redhat.com>
	 <20100419142158.GD14158@mothafucka.localdomain>
	 <4BCC69D5.3050209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:46:51 +0200
Message-ID: <1271688411.1488.248.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 17:33 +0300, Avi Kivity wrote:
> On 04/19/2010 05:21 PM, Glauber Costa wrote:
> >
> >> Oh yes, just trying to avoid a patch with both atomic64_read() and
> >> ACCESS_ONCE().
> >>      
> > you're mixing the private version of the patch you saw with this one.
> > there isn't any atomic reads in here. I'll use a barrier then
> >    
> 
> This patch writes last_value atomically, but reads it non-atomically.  A 
> barrier is insufficient.

What avi says! :-)

On a 32bit machine a 64bit read are two 32bit reads, so

  last = last_value;

becomes:

  last.high = last_value.high;
  last.low  = last_vlue.low;

(or the reverse of course)

Now imagine a write getting interleaved with that ;-)



