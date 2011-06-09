Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1FIQkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:40:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42246 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1FIQkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=cic7QFsw6gecFHOjAqIeBmqcR5gU6HVG8RxMdVxTmwC4/aZj1IddZSxRmmMg7zKgg3
         fVO2U0AnAz3Sqr7m0k5FadW/3GzAVrgQ8aAKb23GseBolThJr/sJp+d32xD2Rs2flLjw
         doWutW1O3vrsrTfJoF5nvpgbwLQms1KUWqxN0=
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <BANLkTimVZxa2pvBqzC3RCg+2o_HzHcwtVQ@mail.gmail.com>
Date: Thu, 9 Jun 2011 18:40:00 +0200
Cc: Al Viro <viro@zeniv.linux.org.uk>, Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Transfer-Encoding: 8BIT
Message-Id: <D167BDC0-BB1A-41B8-A59D-DD60FFA027CE@googlemail.com>
References: <4DEFD979.50405@tilera.com> <1307607243-5737-1-git-send-email-minipli@googlemail.com> <20110609104017.GW11521@ZenIV.linux.org.uk> <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com> <BANLkTimVZxa2pvBqzC3RCg+2o_HzHcwtVQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.06.2011, 17:56 Linus Torvalds wrote:

> On Thu, Jun 9, 2011 at 5:06 AM, Mathias Krause <minipli@googlemail.com> wrote:
>> 
>> ...Albeit by looking closer at the implementation of flush_old_exec()
>> I think we should just move the set_fs() call there and remove it from
>> the architecture dependent implementations of flush_thread() and
>> start_thread().
> 
> Yeah, that sounds like the sane (and safe - it won't matter if there
> are some architectures that get overlooked and then have a duplicate
> set_fs() somewhere) approach.

So the only question left: Should it be one patch moving the set_fs() call to
flush_old_exec() and also removing the redundant calls in flush_thread() and
start_thread() or should that be split into one for the set_fs() move and
multiple ones for the arch specific set_fs() remove?

Mathias