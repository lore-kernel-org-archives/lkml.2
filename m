Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2JVSR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:17:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57178 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2JVSRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-10-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
	<CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
	<alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
Date: Mon, 22 Oct 2012 11:17:24 -0700
X-Google-Sender-Auth: 0OHSDWTD5aNDS1LzWRzclWibWpw
Message-ID: <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 6:19 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:

>> > The series is starting to get in good shape!
>> > I tested it on a 2G and an 8G VM and it seems to be working fine.
>>
>> domU on 32bit and 64bit?
> domU 64bit

Can you test domU 32bit too?
I did not test that, and looks like Jacob only test 64 bit domU too.

>> alloc_low_page() is used in arch/x86/mm/init*.c. How come it becomes
>> interface to
>> other subsystem?
>
> I chose the wrong words.
>
> I meant that always allocating pages from areas that are already mapped,
> will become an assumption for other x86 subsystems like Xen.
> One shouldn't just go ahead and change this assumption without changing
> the subsystems too.

that looks like xen's problem, it should let us know what kind of
assumption that is there for xen.
We can not go deep to xen find those.

> I just want to make sure that 3 years from now, when somebody comes up
> with a new great idea to improve the intial pagetable allocation, he
> doesn't forget that changing alloc_low_page might break other subsystems.
>
> So I think that a comment is required here and should explicitly
> mention why it is important that alloc_low_page returns a mapped page.

How about put sth:
---
Xen mmu requires pages from this function should be directly mapped already.
---

or you can introduce some doc tag specially that we can out those
assumption easily?

Thanks

Yinghai
