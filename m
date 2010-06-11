Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0FKGTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:19:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0FKGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:19:33 -0400
Message-ID: <4C11D51E.3080909@zytor.com>
Date: Thu, 10 Jun 2010 23:18:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 03/13] jump label v9: x86 support
References: <cover.1276116186.git.jbaron@redhat.com> <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com> <1276171930.2077.200.camel@twins> <20100610121440.GA20130@elte.hu>
In-Reply-To: <20100610121440.GA20130@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 05:14 AM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
>>> +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
>>
>> That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
>> useless...
> 
> Hm, we need more than a comment for that - distros enable CC_OPTIMIZE_FOR_SIZE 
> all the time, for the massive kernel image (and hotpath cache footprint) 
> savings. Is this fixable?
> 

Actually the current reports from the gcc community is that gcc 4.5.0 +
-Os produces a broken kernel even without asm goto:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44129

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

