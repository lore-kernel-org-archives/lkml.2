Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab1BNRpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:45:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35362 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BNRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=nAKsAq7eQus6xMJ0x5G/nF33+73BQJ3CN31iOZziftWorfs5+d/fUjD2m2PQio625h
         N6TwB6bP+Uhi/0GXSPff+q1IWkOM/yGxwS6qkuyYncus3DPk95tAEWru/Cv2I4HoUBkm
         RyCF8Xg4GxPEPrfyJOxxL848T3LEVxdJHZXyQ=
MIME-Version: 1.0
In-Reply-To: <1297705095.5226.136.camel@laptop>
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop>
 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop>
 <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com>
 <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com>
 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl> <1297700754.5226.110.camel@laptop>
 <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop>
 <1297702013.23343.51.camel@gandalf.stny.rr.com> <1297703892.23343.71.camel@gandalf.stny.rr.com>
 <1297704447.5226.127.camel@laptop> <AANLkTikB74q7z84g5bmYxZu4kaEdf1kF3z1vpqO=9A45@mail.gmail.com>
 <1297705095.5226.136.camel@laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 14 Feb 2011 12:45:06 -0500
X-Google-Sender-Auth: 76Op97PUNLdRpv-_KAAaiBXK_YM
Message-ID: <AANLkTinftiAqB0j-0UQ0mRWinGjacyN4Jvk2Rgv0-g-T@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "heiko.carstens" <heiko.carstens@de.ibm.com>,
        benh <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 12:38, Peter Zijlstra wrote:
> On Mon, 2011-02-14 at 12:29 -0500, Mike Frysinger wrote:
>> On Mon, Feb 14, 2011 at 12:27, Peter Zijlstra wrote:
>> > On Mon, 2011-02-14 at 12:18 -0500, Steven Rostedt wrote:
>> >> blackfin, seems to be doing quite a lot. Not sure if it is required, but
>> >> that may need a bit of investigating to understand why it does the
>> >> raw_uncached thing.
>> >
>> > From what I can tell its flushing its write cache, invalidating its
>> > d-cache and then issue the read, something which is _way_ overboard.
>>
>> not when the cores in a SMP system lack cache coherency
>
> But atomic_read() is completely unordered, so even on a non-coherent
> system a regular read should suffice, any old value is correct.

the words you use seem to form a line of reasoning that makes sense to
me.  we'll have to play first though to double check.

> The only problem would be when you could get cache aliasing and read
> something totally unrelated.

being a nommu arch, there shouldnt be any cache aliasing issues.
we're just trying to make sure that what another core has pushed out
isnt stale in another core's cache when the other core does the read.
-mike
