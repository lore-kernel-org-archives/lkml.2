Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1JTThI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 15:37:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63311 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JTThG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 15:37:06 -0400
MIME-Version: 1.0
In-Reply-To: <29424.1319100412@redhat.com>
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
	<CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
	<32454.1318519287@redhat.com>
	<CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
	<17609.1318584129@redhat.com>
	<CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com>
	<19081.1319027106@redhat.com>
	<CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com>
	<29424.1319100412@redhat.com>
Date: Thu, 20 Oct 2011 12:37:05 -0700
Message-ID: <CAOH1cHnsFvAAUnBN=Ek7VZ=6JdDsuA0pGdxagUdZoQrWg5oD3A@mail.gmail.com>
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

On Thu, Oct 20, 2011 at 1:46 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> I left the existing cache in place. For a few hours, it was culling
>
> That will be whilst the inode cache was filling, I suspect.
>
>> Is there anything I can do to verify whether the objects are indeed
>> pinned? This is a pretty busy box. The nfs inode cache is quite large
>> (from slabtop):
>
> Hmmm...  Can you get me a dump of /proc/fs/fscache/stats to look at?
>
> The "Objects:" and "Relinqs:" lines are the most interesting.  On the first
> line avl=N shows the number of objects that are in the "available" state -
> ie. are live for caching.
>
> Also, can you do:
>
>        df -i /path/to/cache/partition
>
> to get the number of inodes available and used.


# df /var/cache/fscache/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb6             29338652  16148968  11699352  58% /var/cache/fscache

# df -i /var/cache/fscache/
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb6            1864128  339163 1524965   19% /var/cache/fscache
