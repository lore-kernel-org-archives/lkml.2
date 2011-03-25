Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1CYPCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:02:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:62631 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1CYPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RwG05KSnkFIMh7x4ceilpAvdqH1YbHP8y8kc5NpUBo32rXjchf5BEdHSx+mKqvEumC
         KIVlR6h0TfC4Q2ErM2cZMIfx9uGXyaiLal0fMQYZUB9B/LCnzSCw5/7JuOta6joBwVpm
         1I4429KN/LzFBZSa4omJOr9k+ye8BlJmH+JpM=
Message-ID: <4D8CAE74.9080805@gmail.com>
Date: Fri, 25 Mar 2011 09:02:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110324113209.20235.61900.stgit@localhost6.localdomain6> <4D8B79E6.2050603@gmail.com> <4D8C6B1B.70409@hitachi.com>
In-Reply-To: <4D8C6B1B.70409@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/11 04:14, Akihiro Nagai wrote:
>> On 03/24/11 05:32, Akihiro Nagai wrote:
>>> Provide the function to print pid and command name to
>>> 'perf branch trace'. Users can select items to print with options.
>>> For example,
>>>      'perf branch -p trace' prints only pid,
>>>      'perf branch -ac trace' prints address and comamnd name.
>>>      'perf branch trace' prints only address (default)
>>>
>>> This is output sample (perf branch -ac trace):
>>> command      address
>>> ls           0xffffffff8146fe0e =>  ls           0x0000003806200b20
>>> ls           0xffffffff8146fe0e =>  ls           0x0000003806200b20
>>> ls           0x0000003806200b23 =>  ls           0x0000003806204910
>>> ls           0xffffffff8146fe0e =>  ls           0x0000003806204910
>>> ls           0xffffffff8146fe0e =>  ls           0x0000003806204936
>>> ls           0xffffffff8146fe0e =>  ls           0x000000380620493d
>>> ls           0x0000003806204981 =>  ls           0x00000038062049a3
>>> ls           0x00000038062049a7 =>  ls           0x0000003806204988
>>
>> This can be easily added to perf-script. e.g,
>>
>> perf record -e branches:u -c 1 -d -- ls /tmp
>>
>> perf script -i /tmp/perf.data -f hw:comm,pid,event,sym,addr
>>
>> ...
>> ls  8150 branches: 0x39d30144d0 ffffffff8146a48e  ()
>> ls  8150 branches: 0x39d3014507 ffffffff8146a48e  ()
>> ls  8150 branches: 0x39d3014510            14518 _dl_sysdep_start
>> (/lib64/ld-2.13.so)
>> ...
>> ls  8150 branches: 0x39d3015250             1833 process_envvars
>> (/lib64/ld-2.13.so)
>> ls  8150 branches: 0x39d3015260            1526f _dl_next_ld_env_entry
>> (/lib64/ld-2.13.so)
>> ls  8150 branches: 0x39d3015260            1526f _dl_next_ld_env_entry
>> (/lib64/ld-2.13.so)
> It seems to analyze only 'branch from' address and,
> print 'branch to' address just in hex.
> I would like to analyze both of addresses branch from/to.

from is sample->ip? to is sample->addr? In the above example
0x39d3015260 is the value from sample->addr, 1526f is sample->ip which
resolves to _dl_next_ld_env_entry from /lib64/ld-2.13.so.

> 
> Can perf-script do it by writing scripts?

If you are pulling the data from a perf sample then you can accomplish
the same goal within perf-script.


David
