Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab0C2MJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:09:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45018 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0C2MJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YWWEjz4P/Af5O43FgExOWt3pAHB+mbU41TkAO5iyJsr0TZTAYzUbDJsLh/d8CJMiPU
         5ryG2EeGBG1kE4tef4raGSKRT3oor4D9/2pqGwCh54mWDw6NzxMOQbcC31wk5VUv7Xl8
         PmcAthV2x4nlPQ+Sbaq2c1b/xv6tF7PaOqTzI=
Date: Mon, 29 Mar 2010 20:09:04 +0800
From: anfei <anfei.zhou@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rientjes@google.com,
       kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
Message-ID: <20100329120904.GB11838@desktop>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
 <20100326150805.f5853d1c.akpm@linux-foundation.org>
 <20100326223356.GA20833@redhat.com>
 <20100328145528.GA14622@desktop>
 <20100328162821.GA16765@redhat.com>
 <20100329113113.GA11838@desktop>
 <20100329114630.GA19277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329114630.GA19277@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 01:46:30PM +0200, Oleg Nesterov wrote:
> On 03/29, anfei wrote:
> >
> > On Sun, Mar 28, 2010 at 06:28:21PM +0200, Oleg Nesterov wrote:
> > > On 03/28, anfei wrote:
> > > >
> > > > Assume thread A and B are in the same group.  If A runs into the oom,
> > > > and selects B as the victim, B won't exit because at least in exit_mm(),
> > > > it can not get the mm->mmap_sem semaphore which A has already got.
> > >
> > > I see. But still I can't understand. To me, the problem is not that
> > > B can't exit, the problem is that A doesn't know it should exit. All
> >
> > If B can exit, its memory will be freed,
> 
> Which memory? I thought, we are talking about the memory used by ->mm ?
> 
There is also a little kernel struct related to the task can be freed,
but I think you are correct, the memory used by ->mm takes more effect,
and it won't be freed even B exits. So I agree you on:
"
the problem is not that B can't exit, the problem is that A doesn't know
it should exit. All threads should exit and free ->mm. Even if B could
exit, this is not enough. And, to some extent, it doesn't matter if it
holds mmap_sem or not.
"

Thanks,
Anfei.

> Oleg.
> 
