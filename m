Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0K2DLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 22:11:32 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:34108 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0K2DLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 22:11:31 -0500
Message-ID: <4CF319D9.9060102@pavlinux.ru>
Date: Mon, 29 Nov 2010 06:11:21 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
References: <4CF30B46.4000203@pavlinux.ru> <AANLkTikjDfyWY=Gy7VkdvEGNnYB9kb_iCqNDP7H9W5z4@mail.gmail.com>
In-Reply-To: <AANLkTikjDfyWY=Gy7VkdvEGNnYB9kb_iCqNDP7H9W5z4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2010 05:29, Ming Lei wrote:
> Hi,
>
> 2010/11/29 Pavel Vasilyev <pavel@pavlinux.ru>:
>>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
>>
>> I test on x86_64 (AMD Opteron 285).
> In fact, memcmp doesn't handle case of tail of string, so
> it is not safe to replace strncmp with memcmp
>
#include <stdio.h>
#include <errno.h>

int main() {

   char *STR = "XXXX\0";
   char *XXX = "XXXX";
   int a, b;

     errno = 0; a = memcmp(STR, XXX, 5);  a += errno;
     errno = 0; b = strncmp(STR, XXX, 5); b += errno;
     printf("5 chars: %d %d \n", a, b);
     errno = 0; a = memcmp(STR, XXX, 4);  a += errno;
     errno = 0; b = strncmp(STR, XXX, 4); b += errno;
     printf("4 chars: %d %d \n", a, b);

     printf("SWAP STRINGS\n");

     errno = 0; a = memcmp(XXX, STR, 5);  a += errno;
     errno = 0; b = strncmp(XXX, STR, 5); b += errno;
     printf("5 chars: %d %d \n", a, b);
     errno = 0; a = memcmp(XXX, STR, 4);  a += errno;
     errno = 0; b = strncmp(XXX, STR, 4); b += errno;
     printf("4 chars: %d %d \n", a, b);

return 0;
}
----
# ./a.out
5 chars: 0 0
4 chars: 0 0
SWAP STRINGS
5 chars: 0 0
4 chars: 0 0

But I think the same thing  ;)

-- 

                                                         Pavel.

