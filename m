Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1AKLfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:35:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44239 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1AKLfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:35:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=pURuSovpSScGGiajksDiZvNlMAOGBpL3u+0Md2KYN0VOk2YEoMas+v2D5CcWs6wP8E
         h9WThweUl6BKbJC1lkdLP5gEvR9ft61QsQu6wroiMYo8XC0ljI+fG3QFY9f7ogbFF3Oi
         l7UnypUl2vsnEfsUzn6BAgYiXAh1Ap40JYhGo=
Date: Tue, 11 Jan 2011 09:35:02 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, tzanussi@gmail.com,
        Paul Mackerras <paulus@samba.org>, imunsie@au1.ibm.com,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: perf: commit 55b4462 causes perf record to hang
Message-ID: <20110111113502.GC20234@ghostprotocols.net>
References: <4D2B544F.1050803@cisco.com>
 <20110110200032.GA19703@ghostprotocols.net>
 <alpine.LFD.2.00.1101110927290.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101110927290.12146@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 11, 2011 at 09:28:25AM +0100, Thomas Gleixner escreveu:
> On Mon, 10 Jan 2011, Arnaldo Carvalho de Melo wrote:
> > Can you try with this patch, not reverting tglx's patch?
> > 
> > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> > index 6fb4694..313dac2 100644
> > --- a/tools/perf/util/session.c
> > +++ b/tools/perf/util/session.c
> > @@ -1007,7 +1007,7 @@ more:
> >  	if (size == 0)
> >  		size = 8;
> >  
> > -	if (head + event->header.size >= mmap_size) {
> > +	if (head + event->header.size > mmap_size) {
> >  		if (mmaps[map_idx]) {
> >  			munmap(mmaps[map_idx], mmap_size);
> >  			mmaps[map_idx] = NULL;
> > 
> 
> /me feels stupid

I feel like that sometimes too, probably more often than you :-P

- Arnaldo
