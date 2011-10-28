Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1J1D3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:29:41 -0400
Received: from mail.solarflare.com ([216.237.3.220]:51873 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1J1D3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:29:39 -0400
Message-ID: <1319772566.6759.27.camel@deadeye>
Subject: Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 04:29:26 +0100
In-Reply-To: <1319770376.23112.58.camel@edumazet-laptop>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	 <1319766293.6759.17.camel@deadeye>
	 <1319770376.23112.58.camel@edumazet-laptop>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18474.005
X-TM-AS-Result: No--22.862100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 28 Oct 2011 03:29:39.0580 (UTC) FILETIME=[D32553C0:01CC9521]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 04:52 +0200, Eric Dumazet wrote:
> Le vendredi 28 octobre 2011 à 02:44 +0100, Ben Hutchings a écrit :
> 
> > Whether or not it needs to provide any ordering guarantee, atomic_read()
> > must never read more than once, and I think that requires the volatile
> > qualification.  It might be clearer to use the ACCESS_ONCE macro,
> > however.
> > 
> 
> Where this requirement comes from ?

That is the conventional behaviour of 'atomic' operations, and callers
may depend on it.

> Maybe then introduce atomic_read_once() for users really needing it :)
>
> ACCESS_ONCE will force the read/move instruction I try to avoid :(
[...]

I'm sure you can find some other way to avoid it.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

