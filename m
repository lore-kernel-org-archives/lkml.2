Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1FIR65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:58:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:58243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1FIR6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:58:55 -0400
Subject: Re: Change in functionality of futex() system call.
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dvhart@linux.intel.com, david@rgmadvisors.com, kyle@moffetthome.net,
        luto@mit.edu, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        sbohrer@rgmadvisors.com, zvonler@rgmadvisors.com, hughd@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1307621110.3941.78.camel@twins>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>	<1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
	 <1307383898.3098.90.camel@edumazet-laptop>	<4DED976C.90009@linux.intel.com>
	 <4DEE3944.5020005@mit.edu>	<1307462300.3091.39.camel@edumazet-laptop>
	 <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
	 <BANLkTinHEyRnnJqB=GTwBOAb6aRaHnjQLQ@mail.gmail.com>
	 <BANLkTi=uQmePFOJUx=bdTsnFuFa+ZaYqVw@mail.gmail.com>
	 <BANLkTi=vwJBgkKSY_Cq_jQS-71gH6uOPaw@mail.gmail.com>
	 <BANLkTinL60RXZNH1QW9NdrTv10TckgWFcg@mail.gmail.com>
	 <4DEFA18A.2000808@linux.intel.com>  <4DF0B072.8060204@jp.fujitsu.com>
	 <1307621110.3941.78.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jun 2011 19:58:27 +0200
Message-ID: <1307642307.3941.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 14:05 +0200, Peter Zijlstra wrote:
> On Thu, 2011-06-09 at 20:37 +0900, KOSAKI Motohiro wrote:
> > 1) check the pte of the target address is RW attribute.
> >  2-1) if yes, it has no COW chance. we can safely use gup result.
> >  2-2) if no, we have to fallback slow vma walk. maybe, it's okey.
> >       both RO mappings and COW are rare situation. 
> 
> Not so, clean file pages are RO, even if the vma is writable. We use the
> fault to track dirty state with.

Why can't something like
http://marc.info/?l=linux-kernel&m=130737669810421 work once you restore
the rw argument?
