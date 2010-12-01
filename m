Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0LAPmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:42:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38247 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0LAPmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mi/nq5zfQElDez4gwe+0cDJkK65w2FxintwOloUXiqrKJBKlfT1V8udPir87wtr0vo
         JbKm50GvpiZyIB1KoA8tqUd/+dQAHv62lm+tXb9s4GILsBZyteaeWfN2HOdo+ERyOp8e
         vr7BZesFcFAEKOy/KlZqo1iJ8FeX3e2XDk7sw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinW6Yp8W4x7DxVCY-AttMMWhkxFKXbmqK9fzpVD@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	<20101129081619.GD5218@cr0.nay.redhat.com>
	<AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	<4CF36741.9000808@loongson.cn>
	<AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
	<4CF3762B.9010102@loongson.cn>
	<AANLkTimGn53kwcTYe41Y-fwTQ0vzShLCr3LAr8yW9p=J@mail.gmail.com>
	<AANLkTim44iCdyTsgXohL7TxWCi7=fA8RRZg3kuqUVczx@mail.gmail.com>
	<AANLkTikn31b=Woy3iMQDaZ54iTa1TK2NcJmGf2+Ou1VP@mail.gmail.com>
	<AANLkTinW6Yp8W4x7DxVCY-AttMMWhkxFKXbmqK9fzpVD@mail.gmail.com>
Date: Wed, 1 Dec 2010 23:42:42 +0800
Message-ID: <AANLkTimNHfTWOv8NjM__UFv--pHZ739ML5HXxFhNN+43@mail.gmail.com>
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
From: jovi zhang <bookjovi@gmail.com>
To: Hui Zhu <teawater@gmail.com>, bekars <bekars@gmail.com>,
        qiaochong@loongson.cn
Cc: hellogcc@freelists.org,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't use Chinese word in this mailing list, maybe somebody
need to read LKML guideline firstly.

Does this patch have many use case upon it? if there have many use
case, maybe we can worth to do it, otherwise it maybe need to
consider..., as we known, there have many person debug kernel just
using -O2 or kdb, etc...
we need to think once bring this config option, there will have so
many maintain work on it, every maintainer need to care for their
commit file to make sure the file can work with this -O0 mode.

If there have some files missed to support with the -O0 mode, the
kernel will not stable(also it have a little hard to find which
file/function cause unstable), and the unstable kernel is not
everybody want to see.

>> +ifdef CONFIG_CC_CLOSE_OPTIMIZATION
>> +CFLAGS_process_$(BITS).o       += -O2
>> +CFLAGS_entry_$(BITS).o         += -O2
>> +CFLAGS_traps.o                 += -O2
>> +CFLAGS_i387.o                  += -O2
>> +CFLAGS_xsave.o                 += -O2
>> +CFLAGS_hpet.o                  += -O2

CONFIG_CC_CLOSE_OPTIMIZATION really misunderstand user in here with adding -O2.

   Thanks.
