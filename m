Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1JTJEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab1JTJEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:04:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com>
References: <CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <8905.1317984176@redhat.com> <CAOH1cHkg_eQ!
 RCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com> <CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com> <32454.1318519287@redhat.com> <CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com> <17609.1318584129@redhat.com> <CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com> <19081.1319027106@redhat.com> 
To: Mark Moseley <moseleymark@gmail.com>
Cc: dhowells@redhat.com,
        Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Thu, 20 Oct 2011 10:03:04 +0100
Message-ID: <29711.1319101384@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> Out of curiosity, did the dump of /proc/fs/fscache/stats show anything
> interesting?

Ah...  I missed the attachment.

Looking at the number of pages currently marked (the difference between the
following two numbers):

	Pages  : mrk=3438716 unc=3223887
	...
	Pages  : mrk=7660986 unc=7608076
	Pages  : mrk=7668510 unc=7618591

That isn't very high.  214829 at the beginning, dropping to 49919 at the end.
I suspect this means that a lot of NFS inodes now exist that aren't now cached
(the cache is under no requirement to actually cache anything if it feels it
lacks the resources just to prevent the system from grinding to a halt).

Was the last item in the list just before a crash?  I presume not from your
comments.

> One slightly interesting thing, unrelated to fscache: This box is a
> part of a pool of servers, serving the same web workloads. Another box
> in this same pool is running 3.0.4, up for about 23 days (vs 6 hrs),
> and the nfs_inode_cache is approximately 1/4 of the 3.1.0-rc8's,
> size-wise, 1/3 #ofobjects-wise; likewise dentry in a 3.0.4 box with a
> much longer uptime is about 1/9 the size (200k objs vs 1.8mil objects,
> 45megs vs 400megs) as the 3.1.0-rc8 box. Dunno if that's the result of
> VM improvements or a symptom of something leaking :)

It also depends on what the load consists of.  For instance someone running a
lot of find commands would cause the server to skew in favour of inodes over
data, but someone reading/writing big files would skew it the other way.

Do I take it the 3.0.4 box is not running fscache, but the 3.1.0-rc8 box is?

David

