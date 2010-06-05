Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FEDWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 23:22:15 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:37947 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0FEDWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 23:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VpD4nZ2pTCVg6pguZsR71BMAMUvsOKi92tZuUP5jGPK1cyi8Qk6J0CrnWIgScjlr7f
         Tel7WMDD/8eGRK77BRFQ+jpEq/N97BATZMosJXZ7nqJ4z9VYSjaKCpMDaKsrTY67mJqv
         kTvsRhNJG/9kxVLknjfK40MLeBM6t2TbWWXA8=
Date: Fri, 4 Jun 2010 20:22:26 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: markgross@thegnar.org, 640e9920@gmail.com,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100605032226.GA20419@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100601140519.GC1281@gvim.org>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
 <20100602133910.GA9106@gvim.org>
 <AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
 <20100603031842.GB11311@gvim.org>
 <AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
 <20100603054018.GE11311@gvim.org>
 <AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
 <20100603132449.GA15595@gvim.org>
 <20100603163049.4eba1574@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100603163049.4eba1574@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 04:30:49PM +0200, Florian Mickler wrote:
> On Thu, 3 Jun 2010 06:24:49 -0700
> mark gross <640e9920@gmail.com> wrote:
> 
> > On Thu, Jun 03, 2010 at 12:10:03AM -0700, Arve Hjønnevåg wrote:
> 
> > ok I'm not getting it.
> > is this a fancy com-sci algorithm I should know about?
> > 
> > --mgross
> 
> I think you are at an advantage if you have studied fancy com-sci for
> this? Here is an example:
> 
> say you have 5 constraints: 
> qos1 with a value of 10
> qos2 with 5
> qos3 with 10
> qos4 with 11
> 
> Now, you hash that list by the qos-values:
> 
> 11    ---- 10 	----- 5 
> |	   |  	      |
> qos4	   qos3       qos2
> 	   |
> 	   qos1
> 
> 
> To compute the maximum you just walk the "----" list.
> 
> To reduce qos4 from 11 to 5 you remove it from its "|" list and
> prepend it to the corresponding "|" list.  (4 Pointer adjustments +
> searching the "-----" list for the right place to insert.  
> 
> result:
> 
> 10 ---- 5
> |	|
> qos3	qos4
> |	|
> qos1	qos2
> 
> Cheers,

Oh!  ok, thats easy!

Thanks!!!

--mgross



