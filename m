Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1FFRLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:11:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43011 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FFRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NhkMkYR1+yszfgF2qrdtUdftuymzKFoyx1g8+jyfiHde1ZEKygDizP6P3NoKuLU+IS
         geGupo6KlLHEEeHnbw/VbfKEGwoUJefwy9468Eaheu5FIYmDIdBvy31KAa1dAm6pTIlu
         qi5GHpg+m+ENf7i26AApnlsbWZHAdzpTTAsLI=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307379926.2322.219.camel@twins>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <1307379926.2322.219.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 19:11:37 +0200
Message-ID: <1307380297.3098.74.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 19:05 +0200, Peter Zijlstra a écrit :

> Dunno, using futexes on private file maps is stupid imo, its just asking
> for trouble, ro private file maps are even worse. Forcing the COW is the
> only sane answer in that it gives consistent results and 'breaks' silly
> expectations early instead of sometimes.
> 
> Anyway, that's not really the issue here, as David uses MAP_SHARED (as
> one should if one is interested in the shared value).

Sure, but maybe another guy is 'stupid' and uses MAP_PRIVATE on its
read-only mappings. With old kernels this was working, and we were not
doing the COW.

(Note : the other process writes to the file, using MAP_SHARED)



