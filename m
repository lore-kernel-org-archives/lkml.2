Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2BPTYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:24:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56283 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2BPTYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:24:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D27BA.5090001@xenotime.net>
References: <20120216164144.35e98f5ee8f1b1f545406309@canb.auug.org.au>
	<4F3D27BA.5090001@xenotime.net>
Date: Thu, 16 Feb 2012 14:24:18 -0500
Message-ID: <CACLa4pt8YjxE0T1ApoFphxiKHCQv3DUQ0D7i_aTotLjw1U-GKw@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 16 (selinux)
From: Eric Paris <eparis@parisplace.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's because # CONFIG_NETFILTER is not set

I'll include net/flow.h where I use it rather than get it from the
ridiculous chain:

 In file included from include/linux/netfilter.h:340,
                 from include/net/netns/x_tables.h:5,
                 from include/net/net_namespace.h:19,
                 from include/linux/netdevice.h:49,
                 from include/net/sock.h:50,
                 from include/net/request_sock.h:23,
                 from include/net/netlabel.h:40,
                 from security/selinux/ss/services.c:55:

WHEW!

On Thu, Feb 16, 2012 at 10:58 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 02/15/2012 09:41 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120215:
>
>
> on x86_64:
>
>  CC      security/selinux/ss/services.o
> In file included from /next/linux-next-20120216/security/selinux/ss/services.c:69:0:
> /next/linux-next-20120216/security/selinux/include/xfrm.h: In function 'selinux_xfrm_notify_policyload':
> /next/linux-next-20120216/security/selinux/include/xfrm.h:51:14: error: 'flow_cache_genid' undeclared (first use in this function)
> /next/linux-next-20120216/security/selinux/include/xfrm.h:51:14: note: each undeclared identifier is reported only once for each function it appears in
> make[3]: *** [security/selinux/ss/services.o] Error 1
>
>
> Full randconfig file is attached.
>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
