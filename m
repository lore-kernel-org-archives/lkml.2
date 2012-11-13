Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2KMTNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:13:12 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:29857 "EHLO
	homiemail-a88.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754599Ab2KMTNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:13:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121113174000.6457a68b@pyramind.ukuu.org.uk>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
	<m2fw5mtffg.fsf_-_@firstfloor.org>
	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
	<5086F5A7.9090406@vlnb.net>
	<20121025051445.GA9860@thunk.org>
	<508B3EED.2080003@vlnb.net>
	<20121027044456.GA2764@thunk.org>
	<5090532D.4050902@vlnb.net>
	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>
	<5092D90F.7020105@vlnb.net>
	<20121101212418.140e3a82@pyramind.ukuu.org.uk>
	<50931601.4060102@symas.com>
	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>
	<50A1C15E.2080605@vlnb.net>
	<20121113174000.6457a68b@pyramind.ukuu.org.uk>
Date: Tue, 13 Nov 2012 13:13:05 -0600
Message-ID: <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
From: Nico Williams <nico@cryptonector.com>
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 11:40 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > Barriers are pretty much universal as you need them for power off !
>>
>> I'm afraid, no storage (drives, if you like this term more) at the moment supports
>> barriers and, as far as I know the storage history, has never supported.
>
> The ATA cache flush is a write barrier, and given you have no NV cache
> visible to the controller it's the same thing.
>
>> Instead, what storage does support in this area are:
>
> Yes - the devil is in the detail once you go beyond simple capabilities.

Right: barriers are trivial to program with.  Ordered writes less so.
One could declare all writes to be ordered with respect to each other,
but this will almost certainly hurt performance (at least with disks,
though probably not SSDs) as opposed to barriers, which order one
group of internally-not-order writes relative to another.  And
declaring groups of internally-unordered writes where the groups are
ordered with respect to each other... is practically the same as
barriers.

There's a lot to be said for simplicity... as long as the system is
not so simple as to not work at all.

My p.o.v. is that a filesystem write barrier is effectively the same
as fsync() with the ability to return sooner (before writes hit stable
storage) when the filesystem and hardware support on-disk layouts and
primitives which can be used to order writes preceding and succeeding
the barrier.

Nico
--
