Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab0DHH35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:29:57 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:54273 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab0DHH3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y2DJ5yiB4C4tx/ri83Nslpa+WQQlnOkMcJcq9KQKpVCgvRv+og8pfbAXC9Kz+9tbpb
         yRcTXaOF3G858cOhYQMHlNgivweEXx416wTv0jzL/p74OVpUZ8y/t1DH/TFW9md80UMK
         4UTZVUjGyN0ofsmKG1sPPCyO8Q60XPAKQIXUo=
Message-ID: <4BBD85ED.4090209@iki.fi>
Date: Thu, 08 Apr 2010 10:29:49 +0300
From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: powerpc boot failure
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>	<4BBD81B3.3030500@iki.fi> <20100408172316.e6ee451d.sfr@canb.auug.org.au>
In-Reply-To: <20100408172316.e6ee451d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Thu, 08 Apr 2010 10:11:47 +0300 Timo Teräs <timo.teras@iki.fi> wrote:
>>> The above pc is in this piece of code (I think - I don't have the actual
>>> kernel) from __xfrm_lookup (in net/xfrm/xfrm_policy.c):
>>>
>>>         if ((flags & XFRM_LOOKUP_ICMP) &&
>>>             !(pols[0]->flags & XFRM_POLICY_ICMP)) {
>>>                 err = -ENOENT;
>>>                 goto error;
>>>         }
>>>
>>>         for (i = 0; i < num_pols; i++)
>>>                 pols[i]->curlft.use_time = get_seconds(); <-------- (line 1845)
>>>
>>> And the 0x200000025 is probably &(pols[i]) (which actually seems unlikely
>>> since pols is an array on the stack).
>> What kind of xfrm policies the system has?
> 
> I don't even know what an xfrm policy is :-).  This is a pretty normal Ubuntu
> Gutsy install and wouldn't have anything special in its network setup.
> 
> The above code fragment may be not quite the right place, sorry.  But it
> is the right function.

You don't probably have any xfrm policies then. And that code should not
really get executed.

Some of the changes touch globally visible structs, and inline functions.
Was this a clean rebuild? And did you update all kernel modules, also in
the initramfs?
