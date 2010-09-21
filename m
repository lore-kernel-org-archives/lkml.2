Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0IURgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:36:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55214 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab0IURgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:36:44 -0400
Message-ID: <4C98ECD4.5020606@zytor.com>
Date: Tue, 21 Sep 2010 10:35:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
References: <cover.1284733808.git.jbaron@redhat.com>	 <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>	 <20100921131232.GA3024@one.firstfloor.org>	 <20100921143555.GA2873@redhat.com>	 <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org> <1285082049.23122.1930.camel@gandalf.stny.rr.com>
In-Reply-To: <1285082049.23122.1930.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 08:14 AM, Steven Rostedt wrote:
>>
>>> Also, I think the hash table deals nicely with modules.
>>
>> Maybe but it's also a lot of code. And it seems to me
>> that it is optimizing the wrong thing. Simpler is nicer.
> 
> I guess simplicity is in the eye of the beholder. I find hashes easier
> to deal with than binary searching sorted lists. Every time you add a
> tracepoint, you need to resort the list.
> 
> Hashes are much easier to deal with and scale nicely. I don't think
> there's enough rational to switch this to a binary list.
> 

If all you need is exact matches -- as in this case -- hashes are
generally faster than binary anyway.

	-hpa
