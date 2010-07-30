Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab0G3EDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:03:04 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0G3EDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:03:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aS9Fs2MHoteivt3ZNKRmxqhDM25wRpt3kp5uaO5T0n5bc+oipq7TwxDBT6rMPaJba
	74WtsNEq1UF5wiwImHbjQ==
MIME-Version: 1.0
In-Reply-To: <201007300140.43115.rjw@sisk.pl>
References: <201007282334.08063.rjw@sisk.pl>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100729185529.GW16655@random.random>
	<201007300140.43115.rjw@sisk.pl>
Date: Thu, 29 Jul 2010 21:02:57 -0700
Message-ID: <AANLkTimG_Zq3V9KH4aNyfQZyAAkcydmbgsaANsRake0-@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 4:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, July 29, 2010, Andrea Arcangeli wrote:
>
> I'm afraid that would be difficult to achieve in general.  Besides, there's
> no reason why kernel threads that need not be frozen should care about the
> freezing thing at all.  It's much simpler to require the ones that need to be
> frozen to cooperate.

But it's looking as if any thread which might have to allocate some memory
(and ksmd is on balance a freer of memory, but nonetheless has to do
slab allocations to get there) would need to be frozen.

Except that does not go far enough, because freezing the hibernating
thread (which itself makes memory allocations) won't work out well!

>
>> But for now I'm afraid the below is needed (only ksm.c part applies to
>> upstream).
>
> Looks good to me.
>
> Can you please prepare a patch against mainline for Ondrej to try?

Andrea wasn't proposing his patch for Ondrej's corruption, and I don't
suppose Ondrej even has ksmd running.  Any confusion there is my
fault, for linking Andrea's concerns about suspend and hibernation
with this particular thread on Ondrej's bug.

Hugh
