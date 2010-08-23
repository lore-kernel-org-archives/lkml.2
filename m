Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0HWU3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:29:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40194 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0HWU3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OdL5tpV9p4vhD5WTDoMKzelbM+dj9IUM1UWOsy2+bR+uMogEIEzo0u5bKpBFDv2Rn0
         JGRthhOJwo2hUvN4/j1o+3kEmLkw6IvWGxU0LzAeqCb3riDq59CtGOIEJGj9a8iCMQ8C
         jip1voaaDnATjRDzwbl8XOUva0ssVkVc8H4b8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
	<20100823130109.6da43a58.akpm@linux-foundation.org>
	<AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
	<alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
Date: Mon, 23 Aug 2010 23:29:13 +0300
X-Google-Sender-Auth: sCGHlMvKor1vHcAyabKSmjNHnSE
Message-ID: <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 23 Aug 2010, Pekka Enberg wrote:
>> > Hows about you add a helper function
>> >
>> >        void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
>> >
>> > then convert the callsites to use that, then nuke __GFP_NOFAIL?
>>
>> I'd prefer killing off __GFP_NOFAIL properly :-)

On Mon, Aug 23, 2010 at 11:13 PM, David Rientjes <rientjes@google.com> wrote:
> And how is this not done properly if it's not even needed for any of the
> allocations in this patchset since the page allocator loops forever for
> their orders and context?  (This is why we don't need to add __GFP_NOWARN
> in its place.)
>
> This is a cleanup patchset to remove the unnecessary use of __GFP_NOFAIL,
> there _are_ GFP_KERNEL | __GFP_NOFAIL allocations that need to be
> addressed in phase three.

My point is that I don't think Andrew's helper will change all that
much. Fixing the actual callers is the hard part and I don't see your
patches helping that either. Hiding the looping in filesystem code is
only going to make problematic callers harder to find (e.g
kmem_alloc() in XFS code).

FWIW, I'd just add a nasty WARN_ON in the page allocator and put a big
fat "fix your shit" comment on top of it to motivate people to fix
their code.

                         Pekka
