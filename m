Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1AaVGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:06:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56369 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1AaVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:06:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RUIkxMNPGGZ3Crp0lKNGnHry0AU3NIIhzloyn5ZMdq3PQIslR1UlXxSpWF5NTloBbY
         JJzB+IY74LH6Z1URPb1nJuzVptzMn8hkcYKILSYzAQVTDvGpOw2pIxYVikVY53LrVruc
         TCv0w/TwmyS81BthRGEC9PDrFG85pI0Rtl8K4=
Message-ID: <4D472446.2040501@gmail.com>
Date: Mon, 31 Jan 2011 22:06:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
CC: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: what is spinlock depth
References: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
In-Reply-To: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 09:27 PM, Sri Ram Vemulpali wrote:
> Hi all,
> 
> I am reading spinlock code and looking at struct raw_spinlock. I found
> struct lockdep_map as member.
> which is defined as
> 
> struct lockdep_map {
>        struct lock_class_key           *key;
>        struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
>        const char                      *name;
> #ifdef CONFIG_LOCK_STAT
>        int                             cpu;
>       unsigned long                   ip;
> #endif
> };
> 
> Can anyone help me explain, how this struct helps the spinlock. Why do
> we need lockdepth.

It's not dep-th, but dep-endency. It's a debugging technique to
dynamically check for locking correctness. See more details in
Documentation/lockdep-design.txt.

-- 
js
