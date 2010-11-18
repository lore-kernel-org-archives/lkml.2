Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0KRI2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:28:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48679 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=InmmYVZFrEFwIoEtWJi/JEFqb5RuCkNUPja5K/sqFOJ6Ipw3TfTW7p4bnMnD0wo8US
         AftWIAs9YxV7gKRABO/PS+Mw/wrPOpEkZENeBKcuMlMlUX3W7H6DCcZFFsNl4q/4zS+8
         uljJNawa/oeYwZFi1cdN1u07MHduPF03a9OrA=
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Marcus Meissner <meissner@suse.de>, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101118081241.GA23481@elte.hu>
References: <20101117170822.GW20727@suse.de>
	 <1290014312.2109.1065.camel@laptop>
	 <20101117123039.d975aa70.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1011172137040.2900@localhost6.localdomain6>
	 <20101118081241.GA23481@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 09:28:25 +0100
Message-ID: <1290068905.6782.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 09:12 +0100, Ingo Molnar a écrit :

> We should do something like:
> 
> 	if (!capable(CAP_SYS_ADMIN))
> 		print_ptr = NULL;
> 
> 	sprintf(s, "%p", print_ptr);

A while ago, Thomas suggested following idea :

<quote> 

Considering the amount of duplication you are about to do, you may
want to think about adding a new pointer format extension then. We
already have special '%p' modes for IPv6 addresse, MAC addresses and
various other pointer types. It wouldn't be hard to add one which
does not print (null).

</quote>

http://www.spinics.net/lists/netdev/msg146606.html

So the if (!capable(CAP_SYS_ADMIN)) could be centralized in %pX handling
(X being a new letter, not actually 'X')



