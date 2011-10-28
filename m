Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1J1Jk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:40:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20880 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1J1Jkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:40:55 -0400
Message-ID: <4EAA78DD.2000408@parallels.com>
Date: Fri, 28 Oct 2011 13:41:49 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v3 0/3] SUNRPC: rcbind clients virtualization
References: <20111027180824.20459.23219.stgit@localhost6.localdomain6> <20111027202514.GA31669@fieldses.org> <4EAA74DD.3070708@parallels.com> <20111028093036.GA2604@fieldses.org>
In-Reply-To: <20111028093036.GA2604@fieldses.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.10.2011 13:30, J. Bruce Fields пишет:
> On Fri, Oct 28, 2011 at 01:24:45PM +0400, Stanislav Kinsbursky wrote:
>> This patch-set was created before you've sent your NFSd plan and we
>> disacussed Lockd per netns.
>> So, this sentence: "NFSd service will be per netns too from my pow"
>> is obsolete. And Lockd will be one for all.
>
> I believe lockd should be pert-netns--at least that's what the server
> needs.
>
> (The single lockd thread may handle requests from all netns, but it
> should behave like a different service depending on netns, so its data
> structures, etc. will need to be per-ns.
>

Sure. Looks like we have misunderstanding here. When I said, that Lockd should 
be one for all, I meaned, that we will have only one kthread for all ns (not one 
per ns). Private data will be per net ns, of course.

BTW, Bruce, please, have a brief look at my e-mail to linux-nfs@vger.kernel.org 
named "SUNRPC: non-exclusive pipe creation".
I've done a lot in "RPC pipefs per net ns" task, and going to send first patches 
soon. But right now I'm really confused will this non-exclusive pipes creation 
and almost ready so remove this functionality. But I'm afraid, that I've missed 
something. Would be greatly appreciate for your opinion about my question.

> --b.
>
>> Or you are asking about something else?
>>
>>> --b.
>>>
>>>> And also we have NFSd file system, which
>>>> is not virtualized yet.
>>>>
>>>> The following series consists of:
>>>>
>>>> ---
>>>>
>>>> Stanislav Kinsbursky (3):
>>>>        SUNRPC: move rpcbind internals to sunrpc part of network namespace context
>>>>        SUNRPC: optimize net_ns dereferencing in rpcbind creation calls
>>>>        SUNRPC: optimize net_ns dereferencing in rpcbind registering calls
>>>>
>>>>
>>>>   net/sunrpc/netns.h     |    5 ++
>>>>   net/sunrpc/rpcb_clnt.c |  103 ++++++++++++++++++++++++++----------------------
>>>>   2 files changed, 61 insertions(+), 47 deletions(-)
>>>>
>>>> --
>>>> Signature
>>
>>
>> --
>> Best regards,
>> Stanislav Kinsbursky


-- 
Best regards,
Stanislav Kinsbursky
