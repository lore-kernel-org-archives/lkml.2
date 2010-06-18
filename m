Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0FRMsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:48:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab0FRMsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:48:39 -0400
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20100618122532.GB9045@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	 <1276862130.1875.7.camel@laptop>  <20100618122532.GB9045@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 14:48:24 +0200
Message-ID: <1276865304.1875.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 14:25 +0200, Andi Kleen wrote:
> > So aside from the should this be perf or not, the above is utter
> > gibberish. Whoever came up with this nonsense?
> 
> This is pretty much how softirqs (and before them bottom halves) work.
> I believe Linus invented that scheme originally back in the early
> days of Linux.

Doesn't mean its the right abstraction for this.

> It's actually quite simple and works well

And adds more code than it removes whilst providing a very limited
service.

You generally want to pass more information along anyway, now your
callback function needs to go look for it. Much better to pass a
work_struct like thing around that is contained in the state it needs.


