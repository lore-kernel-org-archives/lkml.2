Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0JYSgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:36:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46721 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0JYSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=thR2QvAdmzox9sAgoJPL9o4vCTVQ7ght+VBTlWuc1aMx8k+vRJEkvsTqj2UyCObcdo
         tCbrxpgj74As3+zo3gPBWn0FsfKTAdP2m46cjPQIwU9gKYguBq2b0a47OrozFPau9jrq
         Sq4PtImw1Md05t/x8loHShdDqAaGryXhLPM8M=
Message-ID: <4CC5CE47.2020607@lwfinger.net>
Date: Mon, 25 Oct 2010 13:36:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net: b43legacy: fix compile error
References: <1288017690-31248-1-git-send-email-arnd@arndnet.de> <4CC5A301.1080606@lwfinger.net> <4CC5CBC4.7060308@arndnet.de>
In-Reply-To: <4CC5CBC4.7060308@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 01:26 PM, Arnd Hannemann wrote:
> Am 25.10.2010 17:32, schrieb Larry Finger:
>> On 10/25/2010 09:41 AM, Arnd Hannemann wrote:
>>> On todays linus tree the following compile error happened to me:
>>>
>>>   CC [M]  drivers/net/wireless/b43legacy/xmit.o
>>> In file included from include/net/dst.h:11,
>>>                  from drivers/net/wireless/b43legacy/xmit.c:31:
>>> include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__' before '____cacheline_aligned_in_smp'
>>> include/net/dst_ops.h: In function 'dst_entries_get_fast':
>>> include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_get_slow':
>>> include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_add':
>>> include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_init':
>>> include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> include/net/dst_ops.h: In function 'dst_entries_destroy':
>>> include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>> make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
>>> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
>>> make[2]: *** [drivers/net/wireless] Error 2
>>> make[1]: *** [drivers/net] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> This patch fixes this issue by adding "linux/cache.h" as an include to
>>> "include/net/dst_ops.h".
>>
>> Strange. Compiling b43legacy from the linux-2.6.git tree (git describe is
>> v2.6.36-4464-g229aebb) works fine on x86_64. I wonder what is different.
> 
> Exactly the same git describe here.
> Maybe your arch includes cache.h already, in my case its a compile for ARM (shmobile).

That probably makes the difference. Using Eric's fix that removes the #include
<linux/dst.h> should be better. Does it work for you?

There are probably a lot more of the system includes that may not be needed. If
I send you a patch removing them, could you test?

Larry
