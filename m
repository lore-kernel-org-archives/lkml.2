Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935685Ab1JFIjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 04:39:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40995 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab1JFIje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 04:39:34 -0400
Message-ID: <4E8D6923.7080404@parallels.com>
Date: Thu, 6 Oct 2011 12:38:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>
Subject: Re: [PATCH v5 6/8] tcp buffer limitation: per-cgroup limit
References: <1317730680-24352-1-git-send-email-glommer@parallels.com>  <1317730680-24352-7-git-send-email-glommer@parallels.com>  <1317732535.2440.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4E8C1064.3030902@parallels.com> <1317805090.2473.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1317805090.2473.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 12:58 PM, Eric Dumazet wrote:
> Le mercredi 05 octobre 2011 à 12:08 +0400, Glauber Costa a écrit :
>> On 10/04/2011 04:48 PM, Eric Dumazet wrote:
>
>>> 2) Could you add const qualifiers when possible to your pointers ?
>>
>> Well, I'll go over the patches again and see where I can add them.
>> Any specific place site you're concerned about?
>
> Everywhere its possible :
>
> It helps reader to instantly knows if a function is about to change some
> part of the object or only read it, without reading function body.
Sure it does.

So, give me your opinion on this:

most of the acessors inside struct sock do not modify the pointers,
but return an address of an element inside it (that can later on be
modified by the caller.

I think it is fine for the purpose of clarity, but to avoid warnings we 
end up having to do stuff like this:

+#define CONSTCG(m) ((struct mem_cgroup *)(m))
+long *tcp_sysctl_mem(const struct mem_cgroup *memcg)
+{
+       return CONSTCG(memcg)->tcp.tcp_prot_mem;
+}

Is it acceptable?
