Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1JMUyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:54:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64135 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1JMUyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <32454.1318519287@redhat.com>
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
	<CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com>
	<9908.1318413955@redhat.com>
	<CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
	<CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
	<32454.1318519287@redhat.com>
Date: Thu, 13 Oct 2011 13:48:44 -0700
Message-ID: <CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
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

On Thu, Oct 13, 2011 at 8:21 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> So on a cleared cache with SLAB, it took a while but this finally came
>> up. One interesting thing is that at some point, it logged this:
>>
>> [13461.605871] [httpd ] <== __fscache_read_or_alloc_pages() = -ENOBUFS
>> [invalidating]
>
> That's okay.  Basically, a read-from-cache operation was rejected because the
> cache object was in the early phase of being invalidated.  I kept it simple
> here - the read might complete next time it is tried, but it's just a cache so
> that shouldn't matter.

Ok, noted


>> It was a while from when it logged that until when I happened to check
>> on the box again, but when I did (shortly before this traceback),
>> despite constant NFS activity, nothing in the fscache cache was
>> getting written out (i.e. the used bytes on the partition stopped
>> changing), and without any messages about withdrawing the cache or
>> anythin.
>
> Did you look at /proc/fs/fscache/stats at all?

I didn't but I can repeat it. Which of the stats in
/proc/fs/fscache/stats would be best to track?


>> [20839.802118] kernel BUG at fs/fscache/object-list.c:83!
>> [20839.802733] invalid opcode: 0000 [#1] SMP
>
> That fits with the previous BUG elsewhere in object-list.c.  It sounds like
> there's a refcounting problem somewhere.

Any sys or proc settings I should turn on to track that?
