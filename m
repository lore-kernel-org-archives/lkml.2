Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1ELTBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:01:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48730 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1ELTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:01:44 -0400
Date: Thu, 12 May 2011 15:01:32 -0400 (EDT)
Message-Id: <20110512.150132.1679483014638599288.davem@davemloft.net>
To: davej@redhat.com
Cc: eranian@google.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110512183741.GA22269@redhat.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<20110512.140630.1779004012724490077.davem@davemloft.net>
	<20110512183741.GA22269@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 12:01:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>
Date: Thu, 12 May 2011 14:37:41 -0400

> On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
>  > I hate this too, and I think it's absolutely rediculous.
>  > 
>  > Also, like you, I lost an entire afternoon trying to figure out why
>  > this started happening.
>  > 
>  > I wish we could revert this change.
> 
> At least it can be permanently disabled..
> 
> echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf

Regardless, what to do about all of the "perf is broken" reports?

First off, perf can find out whether this madness exists, and it
should by default print out a warning in this situation instead of
knowingly emitting garbage kernel event information.

"I'm going to knowingly give you bad data, and I'm not even going to
 let you know about it."

It's really crazy that we give people these incredibly powerful tools
and they don't even work properly by default.

We've been exposing kernel pointers for 20 years, nobody's grandmother
died because of it.

This is very "Animal Farm" the way we're gradually losing little bits
of functionality, time and time again, over this "kernel pointer
exposure" issue.

Are we going to be like animals and just accept the totality of this,
or are we going to be outraged enough to push back on stuff like perf
actually working properly?
