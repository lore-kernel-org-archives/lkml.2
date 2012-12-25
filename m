Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2LYUvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 15:51:33 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40781 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2LYUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 15:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121225112057.GC7720@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-7-git-send-email-yinghai@kernel.org>
	<CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
	<50D0D6D1.70400@zytor.com>
	<CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
	<50D0DB1A.5010407@zytor.com>
	<CAE9FiQV2U+Am0zCz__6YL4CoOeie5McE9=g-L3A_udRNN1rPTw@mail.gmail.com>
	<50D8F054.20404@zytor.com>
	<CAE9FiQW_mjUr6F0q7PhZWCcDzZ+NJpi0-xjxvwJoZ1K+XAUjSQ@mail.gmail.com>
	<20121225112057.GC7720@liondog.tnic>
Date: Tue, 25 Dec 2012 12:51:29 -0800
X-Google-Sender-Auth: lwKqRc6Y0UoP1fIlKdB2E-_D51g
Message-ID: <CAE9FiQWDgKdfA0=6qESAzT1JSLKMht5AYtQnffGyDmECynaMpQ@mail.gmail.com>
Subject: Re: [PATCH v7 06/27] x86, 64bit: early #PF handler set page table
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 3:20 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Dec 24, 2012 at 08:04:18PM -0800, Yinghai Lu wrote:
>> well, I updated for-x86-boot-v7 that stop #PF handler after
>> init_mem_mapping.
>>
>> it has fix for AMD system aka reverting far jmp to ret.
>
> -v7?
>
> You told me yesterday -v8 is the current branch. Do you have -v7 which
> does break KGDB and -v8 which breaks it and both branches are current?
>

-v7: stop #PF handler after init_mem_mapping, so it could break KGDB,
if someone try to use mdump.
-v8: stop #PF handler before x86_64_start_reservations.

Now both have be updated and could work with AMD platform after drop
the change with lretq aka keep lretq.

Yinghai
