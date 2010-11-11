Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0KKRGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:06:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62518 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0KKRF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KJVIYpq9cwwofx2WGHeoS461wpLGurhzt/maRdGfs3Ia+EhqlKm+KJYT3WvQ/NHULT
         5EpO2l6PdAtHesrE1hRwT2MxXFEnpthl12H7blSxcqrGOmUYZg2o0EMB2RWmQ5ynO3mI
         bjMSifkHeVxTBnOf+9oB3Hg8Ogf00uK2MS+yU=
Message-ID: <4CDC2298.1050803@lwfinger.net>
Date: Thu, 11 Nov 2010 11:06:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Arnd Hannemann <arnd@arndnet.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net: b43legacy: fix compile error
References: <1288017690-31248-1-git-send-email-arnd@arndnet.de> <4CC5A301.1080606@lwfinger.net> <4CC5CBC4.7060308@arndnet.de> <4CC5CE47.2020607@lwfinger.net> <4CC5D01C.20804@arndnet.de> <4CC5D3A7.3080709@lwfinger.net> <4CC5E4D2.6080606@arndnet.de> <20101111163531.GB2559@tuxdriver.com>
In-Reply-To: <20101111163531.GB2559@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 10:35 AM, John W. Linville wrote:
> On Mon, Oct 25, 2010 at 10:13:06PM +0200, Arnd Hannemann wrote:
>> Am 25.10.2010 20:59, schrieb Larry Finger:
>>> On 10/25/2010 01:44 PM, Arnd Hannemann wrote:
>>>> Am 25.10.2010 20:36, schrieb Larry Finger:
>>>>> On 10/25/2010 01:26 PM, Arnd Hannemann wrote:
>>>>>> Am 25.10.2010 17:32, schrieb Larry Finger:
>>>>>>> On 10/25/2010 09:41 AM, Arnd Hannemann wrote:
>>>>>>>> On todays linus tree the following compile error happened to me:
>>>>>>>>
>>>>>>>>   CC [M]  drivers/net/wireless/b43legacy/xmit.o
>>>>>>>> In file included from include/net/dst.h:11,
>>>>>>>>                  from drivers/net/wireless/b43legacy/xmit.c:31:
>>>>>>>> include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__' before '____cacheline_aligned_in_smp'
>>>>>>>> include/net/dst_ops.h: In function 'dst_entries_get_fast':
>>>>>>>> include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>>>>>>> include/net/dst_ops.h: In function 'dst_entries_get_slow':
>>>>>>>> include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>>>>>>> include/net/dst_ops.h: In function 'dst_entries_add':
>>>>>>>> include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>>>>>>> include/net/dst_ops.h: In function 'dst_entries_init':
>>>>>>>> include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>>>>>>> include/net/dst_ops.h: In function 'dst_entries_destroy':
>>>>>>>> include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named 'pcpuc_entries'
>>>>>>>> make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
>>>>>>>> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
>>>>>>>> make[2]: *** [drivers/net/wireless] Error 2
>>>>>>>> make[1]: *** [drivers/net] Error 2
>>>>>>>> make: *** [drivers] Error 2
>>>>>>>>
>>>>>>>> This patch fixes this issue by adding "linux/cache.h" as an include to
>>>>>>>> "include/net/dst_ops.h".
>>>>>>>
>>>>>>> Strange. Compiling b43legacy from the linux-2.6.git tree (git describe is
>>>>>>> v2.6.36-4464-g229aebb) works fine on x86_64. I wonder what is different.
>>>>>>
>>>>>> Exactly the same git describe here.
>>>>>> Maybe your arch includes cache.h already, in my case its a compile for ARM (shmobile).
>>>>>
>>>>> That probably makes the difference. Using Eric's fix that removes the #include
>>>>> <linux/dst.h> should be better. Does it work for you?
>>>>>
>>>>> There are probably a lot more of the system includes that may not be needed. If
>>>>> I send you a patch removing them, could you test?
>>>>
>>>> As it turns out my card is not supported by b43legacy, but compilation testing,
>>>> sure I can test that.
>>>
>>> If it is a Broadcom card, it is likely handled by b43.
>>
>> Yes. It seems it should work with b43 (its an SDIO card) and it almost does...
>>
>>> Attached is a trial removal of a number of include statements. Does it compile?
>>
>> Nope:
>> NSTALL_MOD_PATH=/home/arnd/projekte/renesas-2/nfs modules
>>   CHK     include/linux/version.h
>>   CHK     include/generated/utsrelease.h
>> make[1]: `include/generated/mach-types.h' is up to date.
>>   CALL    scripts/checksyscalls.sh
>>   CC [M]  drivers/net/wireless/b43legacy/main.o
>> drivers/net/wireless/b43legacy/main.c: In function 'b43legacy_upload_microcode':
>> drivers/net/wireless/b43legacy/main.c:1688: error: implicit declaration of function 'signal_pending'
>> make[4]: *** [drivers/net/wireless/b43legacy/main.o] Error 1
>> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
> 
> Is this issue resolved?  Should I be expecting a b43 patch?

I don't know if a similar patch for b43 is needed. I tried to set up a cross
compiler for ARM. My initial attempt failed and I did not have time to explore
the situation. If anyone has links to a cross-compiler solution for x86_64 on
openSUSE, please let me know.

Larry
