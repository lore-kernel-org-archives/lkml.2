Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0K2Wtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:49:51 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:12393 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031Ab0K2Wtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:49:49 -0500
Message-ID: <4CF42E5A.7000709@bluewatersys.com>
Date: Tue, 30 Nov 2010 11:51:06 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: pavel@pavlinux.ru, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
References: <4CF30B46.4000203@pavlinux.ru>	 <1291042737.30543.730.camel@gandalf.stny.rr.com>	 <4CF401DD.4000908@pavlinux.ru>	 <1291069113.30543.876.camel@gandalf.stny.rr.com> <1291069616.30543.879.camel@gandalf.stny.rr.com>
In-Reply-To: <1291069616.30543.879.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 11:26 AM, Steven Rostedt wrote:
> On Mon, 2010-11-29 at 17:18 -0500, Steven Rostedt wrote:
> 
>> Um, do you realize that the kernel does not always use the same memcmp
>> as gcc.
>>
> 
> Note, I'm not against the change, because in 99% of the cases, memcmp()
> can and will be faster, and we don't need to worry about these strange
> cases.

It can still break things in subtle ways. Lots of the replacements are
of the form:

  if (strncmp(string, "foo", 3) == 0)

Which can only be replaced with memcmp if the minimum length of string
is _always_ 3. This may be true for some callsites (with careful audit),
but in general I doubt it is and it will lead to subtle bugs.

I hardly think it is worth auditing a bunch of strncmp calls to ensure
that the minimum length of the checked string is always n in order to
remove a single instruction. Making such a change will also introduce
subtle bugs if the rules for the string ever change, eg. a change is
made to allow string = "".

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
