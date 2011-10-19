Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1JSXPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:15:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36792 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1JSXPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <19081.1319027106@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
	<CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
	<CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
	<32454.1318519287@redhat.com>
	<CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
	<17609.1318584129@redhat.com>
	<CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com>
	<19081.1319027106@redhat.com>
Date: Wed, 19 Oct 2011 16:15:20 -0700
Message-ID: <CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 5:25 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> Presumably it gets to bcull and stops storing but nothing's getting pruned.
>
> It is possible that all the objects are pinned by inodes just sitting there in
> the client's inode cache doing nothing.  Thus fscache thinks they're in use.

I wasn't able to run 3.1.0-rc8 on that box over the weekend. I fired
it up this morning though. I left the existing cache in place. For a
few hours, it was culling (Used% on that partition got as low as 60%
at one point, i.e. 'brun'), but now it's back to stuck at 'bcull'.

Is there anything I can do to verify whether the objects are indeed
pinned? This is a pretty busy box. The nfs inode cache is quite large
(from slabtop):

900471 900377  99%    1.02K 300157        3   1200628K nfs_inode_cache

One slightly interesting thing, unrelated to fscache: This box is a
part of a pool of servers, serving the same web workloads. Another box
in this same pool is running 3.0.4, up for about 23 days (vs 6 hrs),
and the nfs_inode_cache is approximately 1/4 of the 3.1.0-rc8's,
size-wise, 1/3 #ofobjects-wise; likewise dentry in a 3.0.4 box with a
much longer uptime is about 1/9 the size (200k objs vs 1.8mil objects,
45megs vs 400megs) as the 3.1.0-rc8 box. Dunno if that's the result of
VM improvements or a symptom of something leaking :)

I don't see any other huge disparities, so I'm hoping it's the former.

Out of curiosity, did the dump of /proc/fs/fscache/stats show anything
interesting?


> Any more oopses from fscache or cachefiles?

The other day when I ran it, I didn't see any oopses after 16 or so
hours. I'll see if I can run it overnight and report back.
