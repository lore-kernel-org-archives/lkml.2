Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0K3K2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:28:18 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6295 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010Ab0K3K2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:28:17 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host oAUARqSM015905
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, pavel@pavlinux.ru,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF42E5A.7000709@bluewatersys.com>
References: <4CF30B46.4000203@pavlinux.ru>
	 <1291042737.30543.730.camel@gandalf.stny.rr.com>
	 <4CF401DD.4000908@pavlinux.ru>
	 <1291069113.30543.876.camel@gandalf.stny.rr.com>
	 <1291069616.30543.879.camel@gandalf.stny.rr.com>
	 <4CF42E5A.7000709@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:27:51 +0100
Message-ID: <1291112871.16068.7.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2010-11-30 at 11:51 +1300, Ryan Mallon wrote:
[...] 
> It can still break things in subtle ways. Lots of the replacements are
> of the form:
> 
>   if (strncmp(string, "foo", 3) == 0)
> 
> Which can only be replaced with memcmp if the minimum length of string
> is _always_ 3. This may be true for some callsites (with careful audit),
> but in general I doubt it is and it will lead to subtle bugs.
> 
> I hardly think it is worth auditing a bunch of strncmp calls to ensure
> that the minimum length of the checked string is always n in order to
> remove a single instruction. Making such a change will also introduce
> subtle bugs if the rules for the string ever change, eg. a change is
> made to allow string = "".

On the conceptual level:
And it will confuse people if strings (read: '\0' terminated char arrays
specified by a pointer to the start) with raw memory (read: memory with
arbitrary content - including '\0' not at the end - specified by a
pointer to the start and the valid size).
Even more confusing is that raw memory *may* hold a string ...

Don't get me wrong: every seasoned C programmer should know that. But
not everyone is one ...

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

