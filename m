Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab0G3Ecl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:32:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0G3Ecj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:32:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=WEILRr8cvhPt1FcleoEhq5yXGbOwiThZUHw5pAczLwysmlILpUNv/ZvGQCD3xqsfL
	NqY31lthtvDVbmHIx3Whw==
MIME-Version: 1.0
In-Reply-To: <20100730041825.GM14369@balbir.in.ibm.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730041825.GM14369@balbir.in.ibm.com>
Date: Thu, 29 Jul 2010 21:32:35 -0700
Message-ID: <AANLkTi=HFg9zcAoUZbYzT2j7X11oDZs=xgrJynT=3GM6@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 9:18 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Couldn't we reuse PF_* flags to differentiate between the paths, if
> that is what it eventually boils down to? On an unrelated note, I was
> looking at shrink_all_memory() and wondering if swappiness really
> mattered there.

So far as the swap-reuse issue goes, I don't see that a PF_ flag
would help: the threads that already worry about such issues do
the set_freezable()/try_to_freeze() thing, and won't get into
trouble anyway; we don't want to force every other thread to
have to do something special now, better just check global state
in the very few places its needed.

On the unrelated note: better in an unrelated thread!

Hugh
