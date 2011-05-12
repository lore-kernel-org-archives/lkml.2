Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1ELNwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:52:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40748 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab1ELNwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=leRtYr3VQzf6y9CsEr3tiGvnkuzTugWloV2npTY0SSImB0RRMXNhCLGzQjQJW1LrCa
         PEpSidhJg6U0YQ+KvK2itwtDBgqdgFNpuAr9n6sPc1aICSDSAMuYjkeJjGfzvrRDmyo2
         FmXKUgr4wxHT1UaWTCYse8dZYYSYvCLQOignM=
MIME-Version: 1.0
In-Reply-To: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
Date: Thu, 12 May 2011 21:52:45 +0800
Message-ID: <BANLkTimHTvo6vkzV1PHJbKL8KtqGQXWPvA@mail.gmail.com>
Subject: Re: problem with kmemleak
From: ttlxzz ccc <boyzccc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did anyone encountered problem like this?

On Thu, May 12, 2011 at 10:06 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> Hi, all:
>
>
>
> I just want to use kmemleak, so I make the CONFIG_DEBUG_KMEMLEAK and
> CONFIG_DEBUG_FS on, mount the debugfs.
>
> But when I insmod mm/kmemleak-test.ko, echo scan >
> /sys/kernel/debug/kmemleak and cat /sys/kernel/debug/kmemleak. I just
> see this:
>
> unreferenced object 0xffffc90012d21000 (size 64):
>
>  comm "insmod", pid 13092, jiffies 4298369684
>
>  hex dump (first 32 bytes):
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>  backtrace:
>
>    [<ffffffffffffffff>] 0xffffffffffffffff
>
> unreferenced object 0xffffc90012d24000 (size 64):
>
>  comm "insmod", pid 13092, jiffies 4298369684
>
>  hex dump (first 32 bytes):
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>  backtrace:
>
>    [<ffffffffffffffff>] 0xffffffffffffffff
>
> unreferenced object 0xffffc90012d27000 (size 64):
>
>  comm "insmod", pid 13092, jiffies 4298369684
>
>  hex dump (first 32 bytes):
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>
>  backtrace:
>
>    [<ffffffffffffffff>] 0xffffffffffffffff
>
> There is no other backtrace except [<ffffffffffffffff>]
> 0xffffffffffffffff. Then I read the mm/kmemleak.c. In
> kmemleak_seq_show(), I find that the object->trace_len is 1.
>
>
>
> How can I get the full backtrace?
>
