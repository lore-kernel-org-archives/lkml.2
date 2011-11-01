Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1KAI6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:58:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50051 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1KAI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:58:34 -0400
Message-ID: <4EAFB34D.8080807@gmail.com>
Date: Tue, 01 Nov 2011 09:52:29 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>	<4EAC0C18.5090602@gmail.com>	<CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>	<4EAD360D.6010004@gmail.com>	<CAEYUcX2yF1hw=D8XHMGE7p4Tty+G-vmVudNsFHXUOSTGGKoq=w@mail.gmail.com>	<4EAE630A.6040309@gmail.com> <CAEYUcX3dzG_DCBSj570qGoeM00NhjCBHLS7sLKvDw2jvUJnjVg@mail.gmail.com>
In-Reply-To: <CAEYUcX3dzG_DCBSj570qGoeM00NhjCBHLS7sLKvDw2jvUJnjVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/11/2011 00:03, Bryan Freed ha scritto:
> On Mon, Oct 31, 2011 at 1:57 AM, Marco Stornelli
>>> And I cannot shake the feeling that we have a fairly simple disconnect
>>> here.  Ramoops expects to use _device_ memory because it uses
>>> ioremap().  But the buffer itself is accessed through /dev/mem which
>>> (as we use it with no mmap() calls) expects to give access to _system_
>>
>> no mmap calls?! I don't understand how you are using /dev/mem.
>
> open(), lseek(), read().  No mmap is required for RAM, right?
> dd if=/dev/mem bs=1 count=1000 skip=32M
>

Mmmm, the operations done are different. Try: reserve the memory with 
memblock_reserve and read some data with this useful program 
http://free-electrons.com/pub/mirror/devmem2.c from the right location 
(the address used for ramoops).

Let me know.

Marco
