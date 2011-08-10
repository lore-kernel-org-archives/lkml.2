Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1HJQwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:52:25 -0400
Received: from smtp23.services.sfr.fr ([93.17.128.21]:11241 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1HJQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:52:24 -0400
X-SFR-UUID: 20110810165221224.36AEF7000149@msfrf2312.sfr.fr
Message-ID: <4E42B940.6070904@efixo.com>
Date: Wed, 10 Aug 2011 19:00:48 +0200
From: Emmanuel Deloget <emmanuel.deloget@efixo.com>
Reply-To: emmanuel.deloget@efixo.com
Organization: Efixo
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org>	 <1312067670.22074.61.camel@i7.infradead.org>	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>	 <4E34998D.8060806@zytor.com>	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>	 <4E4140B3.7090802@suse.cz>	 <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>	 <1312985888.2989.46.camel@i7.infradead.org>	 <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com> <1312993987.2989.53.camel@i7.infradead.org>
In-Reply-To: <1312993987.2989.53.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 06:33 PM, David Woodhouse wrote:
> On Wed, 2011-08-10 at 10:34 -0400, Arnaud Lacombe wrote:
>> your point being ? I might as well tell you that I find the current
>> behavior of 'all*.config' just as broken wrt. to dependency
>> management.
> You might indeed. And I would find that commentary just as irrelevant
> and unhelpful.
>
>>> If you have nothing relevant to say, just don't say anything.
>>>
>> maybe you can come with a detailed description of your proposal's
>> behavior, including how to manage case like this, instead of just
>> throwing patch around ?
> How's this for a definition:
>
> "The behaviour for unsettable (or unclearable) options shall be exactly
> like it already is if you put them in all*.config, or if you manually
> edit the .config file and run 'make oldconfig', as people have been
> doing for years. There is nothing new to see here."
>
>> If I do:
>>
>> # make CONFIG_WIRELESS_EXT=y allnoconfig
>>
>> I expect either a success or an error, not a silent discard. And
>> *yes*, the problem already exists with "all*.config".
> [dwmw2@i7 linux-2.6]$ make CONFIG_WIRELESS_EXT=y allnoconfig
> scripts/kconfig/conf --allnoconfig Kconfig
> #
> # Could not set CONFIG_WIRELESS_EXT=y; perhaps it has unmet dependencies?
> #
> #
> # configuration written to .config
> #
>

I understand that my question is indeed neither wanted nor clever, but 
what's the point of trying to support "make CONFIG_FOO=y"?

Will we be expected to type a 42 meters long command line to compile the 
kernel instead of doing a menuconfig in the foreseable future? (and 
between typos, unmet dependencies and the myriad of other possible 
errors, I'm not sure I'll get more free time).

I don't get it. If the goal is to help the kernel hackers and if it 
really helps them it might be a thing to do - it might prove useful for 
very simple CONFIG_ options but I'm not sure this will stay true for the 
general case.

Best regards,

-- Emmanuel

