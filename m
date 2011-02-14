Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1BNRYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:24:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BNRYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:24:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WmpZIHSZiIamSabFwWE3/EL0zR9eJXs0KUDnnZZufF6Vd83kLyNY9rBlmoM/jmSxW3
         tFz4ePXdPqPGxNrwJCuyELm5ImpxXosS2W390OOhn8t2eTinzeHHjpT5tO2n4sNrl5Hs
         L2gZI1NpUjRqaLpCJAbPylQVM42P0a0RwfByE=
MIME-Version: 1.0
In-Reply-To: <1297703892.23343.71.camel@gandalf.stny.rr.com>
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop>
 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop>
 <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com>
 <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com>
 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl> <1297700754.5226.110.camel@laptop>
 <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop>
 <1297702013.23343.51.camel@gandalf.stny.rr.com> <1297703892.23343.71.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Feb 2011 12:23:44 -0500
Message-ID: <AANLkTinbKhZXYHjFD5fDXzCt8myiQ_GrVNgKGaMqO9Ot@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 12:18, Steven Rostedt wrote:
> blackfin:
> #define atomic_read(v)  __raw_uncached_fetch_asm(&(v)->counter)
>
> blackfin, seems to be doing quite a lot. Not sure if it is required, but
> that may need a bit of investigating to understand why it does the
> raw_uncached thing.

this is only for SMP ports, and it's due to our lack of
cache-coherency.  for non-SMP, we use asm-generic.
-mike
