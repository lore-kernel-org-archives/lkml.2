Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0IUS7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:59:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60918 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0IUS7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:59:52 -0400
Message-ID: <4C990070.7080807@zytor.com>
Date: Tue, 21 Sep 2010 11:58:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com> <20100921182945.GA22088@dumpdata.com> <20100921185513.GA22929@dumpdata.com>
In-Reply-To: <20100921185513.GA22929@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 11:55 AM, Konrad Rzeszutek Wilk wrote:
>>> +early_initcall(init_jump_label);
>>
>> Is there any danger of not patching the instructions with NOPs before
>> early_initcall is called? I guess for your uses (tracing) there won't.
>> And even if there are not patched it will just call the function.
> 
> Ah, nevermind - if you don't patch the addresses which are in
> _jump_label section, the untouched code will just do far jump (jmpq)
> to right after the macro, which is ok.

Technical point of order: jmpq is *NOT* a far jump.  A far jump (called
ljmp in gas) is a completely different x86 instruction with *very*
different semantics.

	-hpa

