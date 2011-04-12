Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1DLNI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:08:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1DLNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y9ZKGy5I8/3xdU8vzvT4t4F7VzEJTumo/2hc0UV50WxlOfm7VDyakuOXlyuYkCo3vv
         AgoRxzbFL4Cy7c9M7KT5QEqldFEgQMXUbLGLIZdlpSKKzHofcUVCXbRhGPh1dAtsaSQ6
         DzfWqxiPVvmruvoI0GAO3u+CiNVrDZt0uZ3AQ=
Subject: Re: Loopback and Nagle's algorithm
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Adam McLaurin <lkml@irotas.net>, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1104121354010.6953@twin.jikos.cz>
References: <1302575869.13492.1440076201@webmail.messagingengine.com>
	 <BANLkTi=jpdLRc35DkBhLmUr8-P+ggcrgoA@mail.gmail.com>
	 <1302606246.21782.1440195277@webmail.messagingengine.com>
	 <alpine.LRH.2.00.1104121354010.6953@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 15:08:23 +0200
Message-ID: <1302613703.3233.40.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 avril 2011 à 13:54 +0200, Jiri Kosina a écrit :
> On Tue, 12 Apr 2011, Adam McLaurin wrote:
> 
> > > It may be caused by an increase in context switch rate, as both sender
> > > and receiver are on the same machine.
> > 
> > I'm not sure that's what's happening, since the box where I'm running
> > this test has 8 physical CPU's and 32 cores in total.
> 
> Have you tried firing up the testcase under perf, to see what it reveals 
> as the bottleneck?
> 
CC netdev

This rings a bell here.

I suspect we hit mod_timer() / lock_timer_base()  because of delack
timer constantly changing.

I remember raising this point last year :

http://kerneltrap.org/mailarchive/linux-netdev/2010/5/20/6277741

David answer : 
http://kerneltrap.org/mailarchive/linux-netdev/2010/6/2/6278430

I am afraid no change was done...


