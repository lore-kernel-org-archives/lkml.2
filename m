Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992512Ab2KOBRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:17:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62526 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992458Ab2KOBRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:17:38 -0500
Message-ID: <50A442AF.9020407@vlnb.net>
Date: Wed, 14 Nov 2012 20:17:35 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Nico Williams <nico@cryptonector.com>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Richard Hipp <drh@hwaci.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com>
In-Reply-To: <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:BAYB8hqecJzUS01Bjm/pC2PV2XloY1zqf5jOyfQnP8o
 UkBdjEQV+jiWyqunSV2Fh35Fd0iA/3t/4vGG6ZF7jA1w5/Wtgn
 jVVs5MP4xtgyq4iYmuwVk8tc+jBiHWafBZmbASoYSbQcLRZBvk
 W3xQEbhHydb8qwwMtu+BD+R0gSFMrZsbyw6MCOT23jFs5Gz5pi
 j44qfswBFs9agdhT927knVWOBEH9JbRjFYDrWc6clIaTZeVCa8
 2edNdvW8e6oiijAhRcFqhXLbykdHafuM//nSb6X5HtdgYlvS95
 uWwqVYS5Zz/c3TxBfkjFdqMTNiYVGIpaJANerIx8skee8LotXd
 orteyzTzLi57JmyVcHb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nico Williams, on 11/13/2012 02:13 PM wrote:
> declaring groups of internally-unordered writes where the groups are
> ordered with respect to each other... is practically the same as
> barriers.

Which barriers? Barriers meaning cache flush or barriers meaning commands order, 
or barriers meaning both?

There's no such thing as "barrier". It is fully artificial abstraction. After all, 
at the bottom of your stack, you will have to translate it either to cache flush, 
or commands order enforcement, or both.

Are you going to invent 3 types of barriers?

> There's a lot to be said for simplicity... as long as the system is
> not so simple as to not work at all.
>
> My p.o.v. is that a filesystem write barrier is effectively the same
> as fsync() with the ability to return sooner (before writes hit stable
> storage) when the filesystem and hardware support on-disk layouts and
> primitives which can be used to order writes preceding and succeeding
> the barrier.

Your mistake is that you are considering barriers as something real, which can do 
something real for you, while it is just a artificial abstraction apparently 
invented by people with limited knowledge how storage works, hence having very 
foggy vision how barriers supposed to be processed by it. A simple wrong answer.

Generally, you can invent any abstraction convenient for you, but farther your 
abstractions from reality of your hardware => less you will get from it with 
bigger effort.

There are no barriers in Linux and not going to be. Accept it. And start instead 
thinking about offload capabilities your storage can offer to you.

Vlad

