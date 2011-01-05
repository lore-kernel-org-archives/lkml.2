Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1AESxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:53:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1AESxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:53:38 -0500
Message-ID: <4D24BDD5.5090803@zytor.com>
Date: Wed, 05 Jan 2011 10:52:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
References: <cover.1294239591.git.jbaron@redhat.com>	 <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>	 <20110105171516.GB1692@nowhere> <1294249596.26623.38.camel@gandalf.stny.rr.com>
In-Reply-To: <1294249596.26623.38.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 09:46 AM, Steven Rostedt wrote:
> On Wed, 2011-01-05 at 18:15 +0100, Frederic Weisbecker wrote:
>> On Wed, Jan 05, 2011 at 10:43:12AM -0500, Jason Baron wrote:
>>> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
>>> index 152f7de..0ad9c2e 100644
>>> --- a/include/linux/jump_label.h
>>> +++ b/include/linux/jump_label.h
>>> @@ -22,6 +22,11 @@ struct module;
>>>  
>>>  #ifdef HAVE_JUMP_LABEL
>>>  
>>> +static __always_inline bool static_branch(struct jump_label_key *key)
>>> +{
>>> +	return __static_branch(key);
>>
>> Not very important, but __static_branch() would be more self-explained
>> if it was called arch_static_branch().
> 
> I disagree, I think it is very important ;-)
> 
> Yes, the kernel has been moving to adding "arch_" to functions that are
> implemented dependently by different archs. Please change this to
> "arch_static_branch()".
> 

Indeed.  This hugely simplifies knowing where to look and whose
responsibility it is.

	-hpa
