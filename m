Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab2HIWcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:32:24 -0400
Received: from n2-vm3.bullet.mail.ne1.yahoo.com ([98.138.229.211]:40727 "EHLO
	n2-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607Ab2HIWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:32:21 -0400
X-Yahoo-Newman-Id: 700993.38762.bm@smtp102.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WmniT2YVM1lp9IMnXg1llmaLNFsE36IbsYLT863YNlEp2zO
 Fh9BiJUCqdaahm99PXcSdZr9H.PMyEc2J21e9RTWQGgPxwOsaDid.LlcVSrD
 0EHETdiS_02.UjsPXbAYTwZ7M5YA_Nl33F6rmN0MEH_XxzAAF0jWP1mR6rEK
 gNhAZsiQELIoMLnGN1W33X75.20BF4mrzpwsyrlayMn8jEm.Nfq3f0AHwVuB
 t8HsYSdV33xYs8dADLbfkdBhREBHNmmm9tCjjTiM_BNmQQvGQTarWZ_fqiff
 _ts15o15DaFScmUFzwRQLcb4hDdkbghf2tDZWKIZrSyOsgd5YLJs_Xk._7r.
 7IOsiNvbgIx7gs2pmJiq1LyotfNvF_x2QzX7bRiV5v3dEgdTN.i1pHkcbuSZ
 wkwt7fGodKP8JGcDP6yQYuHk1DA.hGgQJR677R6wHoO8Gc20dzRyI.lKwy0Y
 pBYbjTcXNEw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5024392D.3060608@schaufler-ca.com>
Date: Thu, 09 Aug 2012 15:26:53 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] ipv4: tcp: security_sk_alloc() needed for unicast_sock
References: <50215A7E.8000701@linaro.org>  <1344462889.28967.328.camel@edumazet-glaptop>  <5022FD9A.4020603@schaufler-ca.com> <1695034.0lrQgQPOMT@sifl>  <1344523833.28967.996.camel@edumazet-glaptop>  <CACLa4ptkvKj2GT4ZL+msMuWOHW885Hugk8nz3hvptOoY9-totw@mail.gmail.com>  <1344547743.31104.582.camel@edumazet-glaptop>  <5024313F.1010404@schaufler-ca.com> <1344549920.31104.701.camel@edumazet-glaptop>
In-Reply-To: <1344549920.31104.701.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2012 3:05 PM, Eric Dumazet wrote:
> On Thu, 2012-08-09 at 14:53 -0700, Casey Schaufler wrote:
>> On 8/9/2012 2:29 PM, Eric Dumazet wrote:
>>> smack_sk_alloc_security() uses smk_of_current() : What can be the
>>> meaning of smk_of_current() in the context of 'kernel' sockets...
>> Yes, and all of it's callers - to date - have had an appropriate
>> value of current. It is using the API in the way it is supposed to.
>> It is assuming a properly formed socket. You want to give it a
>> cobbled together partial socket structure without task context.
>> Your predecessor did not have this problem.
> My predecessor ? You mean before the patch ?
>
> tcp socket was preallocated by at kernel boot time.
>
> What is the 'user' owning this socket ?
>
> You guys focus on an implementation detail of TCP stack.
> You should never use this fake socket.
>
> I repeat : There are no true socket for these control packets.
>
> If you want them, then you'll have to add fields in timewait socket.
>
> I can decide to rewrite the whole thing just building a TCP packet on
> its own, and send it without any fake socket.
>
> Some guy 15 years ago tried to reuse some high level functions, able to
> build super packets and use sophisticated tricks, while we only want so
> send a 40 or 60 bytes packet.

OK, fine. You have an optimization. I'm good with that. Just don't
expect that the entire software stack you are taking advantage of
is going to change to accommodate your special case.

