Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1LMN63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:58:29 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:59804 "EHLO
	smtp5.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1LMN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:58:20 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp5.sgsi.ucl.ac.be 68FE311E711
Message-ID: <4EE757D7.6060006@uclouvain.be>
Date: Tue, 13 Dec 2011 14:49:11 +0100
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?UTF-8?B?VW5pdmVyc2l0w6kgQ2F0aG9saXF1ZSBkZSBMb3V2YWlu?=
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: glommer@parallels.com, linux-kernel@vger.kernel.org, paul@paulmenage.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org, eric.dumazet@gmail.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory pressure
 controls
References: <1323676029-5890-1-git-send-email-glommer@parallels.com> <20111212.190734.1967808916779299221.davem@davemloft.net>
In-Reply-To: <20111212.190734.1967808916779299221.davem@davemloft.net>
X-TagToolbar-Keys: D20111213144911261
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 68FE311E711.A0274
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/13/2011 01:07 AM, David Miller wrote:
> From: Glauber Costa <glommer@parallels.com>
> Date: Mon, 12 Dec 2011 11:47:00 +0400
> 
>> This series fixes all the few comments raised in the last round,
>> and seem to have acquired consensus from the memcg side.
>>
>> Dave, do you think it is acceptable now from the networking PoV?
>> In case positive, would you prefer merging this trough your tree,
>> or acking this so a cgroup maintainer can do it?
> 
> All applied to net-next, thanks.

now there are plenty of compiler-warnings when CONFIG_CGROUPS is not set:

In file included from include/linux/tcp.h:211:0,
                 from include/linux/ipv6.h:221,
                 from include/net/ip_vs.h:23,
                 from kernel/sysctl_binary.c:6:
include/net/sock.h:67:57: warning: ‘struct cgroup_subsys’ declared
inside parameter list [enabled by default]
include/net/sock.h:67:57: warning: its scope is only this definition or
declaration, which is probably not what you want [enabled by default]
include/net/sock.h:67:57: warning: ‘struct cgroup’ declared inside
parameter list [enabled by default]
include/net/sock.h:68:61: warning: ‘struct cgroup_subsys’ declared
inside parameter list [enabled by default]
include/net/sock.h:68:61: warning: ‘struct cgroup’ declared inside
parameter list [enabled by default]


Because struct cgroup is only declared if CONFIG_CGROUPS is enabled.
(cfr. linux/cgroup.h)


Christoph

-- 
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://mptcp.info.ucl.ac.be
Université Catholique de Louvain
-- 
