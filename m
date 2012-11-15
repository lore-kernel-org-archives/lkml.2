Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2KOWhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:37:33 -0500
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:46718 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:37:32 -0500
Message-ID: <50A56E43.3040805@genband.com>
Date: Thu, 15 Nov 2012 16:35:47 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Ryan Johnson <ryan.johnson@cs.utoronto.ca>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Nico Williams <nico@cryptonector.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>	<m2fw5mtffg.fsf_-_@firstfloor.org>	<CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>	<5086F5A7.9090406@vlnb.net>	<20121025051445.GA9860@thunk.org>	<508B3EED.2080003@vlnb.net>	<20121027044456.GA2764@thunk.org>	<5090532D.4050902@vlnb.net>	<20121031095404.0ac18a4b@pyramind.ukuu.org.uk>	<5092D90F.7020105@vlnb.net>	<20121101212418.140e3a82@pyramind.ukuu.org.uk>	<50931601.4060102@symas.com>	<20121102123359.2479a7dc@pyramind.ukuu.org.uk>	<50A1C15E.2080605@vlnb.net>	<20121113174000.6457a68b@pyramind.ukuu.org.uk> <CAK3OfOgK7a9+g-KU8v5-b2d+8-vLb75kuKKQnPK-zeFV1fLmxw@mail.gmail.com> <50A442AF.9020407@vlnb.net> <50A52133.9050204@cs.utoronto.ca>
In-Reply-To: <50A52133.9050204@cs.utoronto.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2012 22:35:48.0842 (UTC) FILETIME=[8F71F4A0:01CDC381]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19370.002
X-TM-AS-Result: No--12.362100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 11:06 AM, Ryan Johnson wrote:

> The easiest way to implement this fsync would involve three things:
> 1. Schedule writes for all dirty pages in the fs cache that belong to
> the affected file, wait for the device to report success, issue a cache
> flush to the device (or request ordering commands, if available) to make
> it tell the truth, and wait for the device to report success. AFAIK this
> already happens, but without taking advantage of any request ordering
> commands.
> 2. The requesting thread returns as soon as the kernel has identified
> all data that will be written back. This is new, but pretty similar to
> what AIO already does.
> 3. No write is allowed to enqueue any requests at the device that
> involve the same file, until all outstanding fsync complete [3]. This is
> new.

This sounds interesting as a way to expose some useful semantics to 
userspace.

I assume we'd need to come up with a new syscall or something since it 
doesn't match the behaviour of posix fsync().

Chris
