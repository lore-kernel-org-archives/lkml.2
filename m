Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1EKQqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:46:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab1EKQqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PlNlIZ4k5MpOW5UTVVhHmu5MEUn32/jNAHFmhXiLloBu+3Jh9HaSb4dciBSjjcfk3y
         wkg1M7Myi0sKzgShSqOup/q94HQzJmhqtv+H9N1vNpkD8g8EAf/6+8HrWevD/s6TBRE9
         21h2NAGYDBt+Z6rKcnJWegcY+32W45T6lMl2M=
MIME-Version: 1.0
In-Reply-To: <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
Date: Wed, 11 May 2011 11:19:22 +0200
X-Google-Sender-Auth: vbV-hnsqD-iChMS_V60zIdA018E
Message-ID: <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

2011/5/11 Alessio Igor Bogani <abogani@kernel.org>:
> 2011/5/11 Mike Frysinger <vapier.adi@gmail.com>:
>> this breaks symbol prefixed arches (like Blackfin):
>>  CC      kernel/softirq.o
>> /tmp/ccp3A6LU.s: Assembler messages:
>> /tmp/ccp3A6LU.s:3734: Error: symbol `___ksymtab__local_bh_enable' is
>> already defined
>> make[1]: *** [kernel/softirq.o] Error 1
>
> Could you provide the preprocessed file and details about the toolchain used?

Please ignore this now I can reproduce the problem on my machine.

>> name.  so rather than "__", use "+".

Sorry I don't think that is a good choice from a long term point of
view. What do you think to add MODULE_SYMBOL_PREFIX to section names
instead? In this way symbol and section names should always be
different also on symbol prefixed archs (which are blackfin and
h8300).

Thank you very much!

Ciao,
Alessio
