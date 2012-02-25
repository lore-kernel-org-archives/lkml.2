Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2BYJhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 04:37:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab2BYJhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 04:37:34 -0500
Message-ID: <4F48ABD9.2010406@suse.cz>
Date: Sat, 25 Feb 2012 10:37:29 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix use of parenthesis in regex
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net> <4F2C38BD.1060109@codeaurora.org> <20120203121847.1b01f4b5@s6510.linuxnetplumber.net> <c1f3d71b6001dfc42ded4ee651e9a82c.squirrel@www.codeaurora.org> <20120206124058.1cf1a23e@s6510.linuxnetplumber.net> <4F305CB6.7050603@codeaurora.org> <20120206151543.1bb1d869@s6510.linuxnetplumber.net> <20120225003411.GA27390@sepie.suse.cz> <20120224165602.6fe303d3@nehalam.linuxnetplumber.net>
In-Reply-To: <20120224165602.6fe303d3@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 25.2.2012 01:56, Stephen Hemminger napsal(a):
> On Sat, 25 Feb 2012 01:34:12 +0100
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> On Mon, Feb 06, 2012 at 03:15:43PM -0800, Stephen Hemminger wrote:
>>> Several of the regular expressions passed to etags and ctags where incorrect
>>> and missing the backslash before the closing paren, and matching the wrong
>>> part of the start of the function causing warning:
>>>   etags: Unmatched ( or \( while compiling pattern
>>
>> But your patch introduces another imbalances, e.g.
>>
>>
>>> @@ -129,31 +129,31 @@ exuberant()
>> ...
>>> -	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
>> ...
>>> +	--regex-c++='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
>>
>> The old version had left paren, start of group, ..., end of group
>> The new version has start of group, left paren, ..., right paren
>>
>> Where left / right paren means the character without any special
>> meaning. I actually can't see anything wrong with the old TRACE_EVENT matching, the regular expression is correct and I think it does what it should do (turn
>> TRACE_EVENT(foo) into trace_foo).
>>
>> Below is the full list of warnings I get from
>>
>> Exuberant Ctags 5.8, Copyright (C) 1996-2009 Darren Hiebert
>>   Addresses: <dhiebert@users.sourceforge.net>, http://ctags.sourceforge.net
>>   Optional compiled features: +wildcards, +regex
>>
>>
>>   GEN     tags
>> ctags: Warning: regcomp ^SYSCALL_DEFINE[[:digit:]]?(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp ^TRACE_EVENT(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp ^DEFINE_EVENT\([^,)]*, *([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp PAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp PAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp PAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTSETFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTPAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp SETPAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __SETPAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTCLEARFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __TESTCLEARFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp CLEARPAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __CLEARPAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __PAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __PAGEFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp PAGEFLAG_FALSE(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTSCFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTSCFLAG(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp SETPAGEFLAG_NOOP(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp CLEARPAGEFLAG_NOOP(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __CLEARPAGEFLAG_NOOP(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp TESTCLEARFLAG_FALSE(\([^,)]*\).*: Unmatched ( or \(
>> ctags: Warning: regcomp __TESTCLEARFLAG_FALSE(\([^,)]*\).*: Unmatched ( or \(
>>
>> The same list repeats, as ctags is called multiple times.
>>
>> Michal
> 
> The problem is that in proper regex each start of sub-expression \(
> needs to have a matching end of sub-expression \)

But both *tags programs expect extended regexps, where \( is not start
of sub-expression, but a verbatim left paren. So you balanced verbatim
parens (which was not necessary, as the right paren is eaten by the
trailing .*) and broke expression grouping.

Michal
