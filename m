Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0F1RRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:17:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44543 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0F1RRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V2ZySTa3hs1IgRp+uZhBD7UlmlRCsax4ZZSry1wRXLS1IlYw0tOzSC7/lGfw5jbXTc
         DD5CgkwWZ9NfKU1B8mnARjK01Yk7u8Q+k/Vk4PqxR3ptTdWS5bliK9OgMmJ7AKBqQD8t
         XCGHe+seEIf5nwtmSYayCTo11YJoEVVH3xijM=
MIME-Version: 1.0
In-Reply-To: <201006182035.17394.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<20100618172121.528f2e09@lxorguk.ukuu.org.uk>
	<AANLkTikfqHO1x0P_iyYTsGGjDcZGCEmZFPUDWiKzk2SQ@mail.gmail.com>
	<201006182035.17394.arnd@arndb.de>
Date: Mon, 28 Jun 2010 10:17:39 -0700
X-Google-Sender-Auth: wU7e3hBvZrClMRPC50ajeQcDdK0
Message-ID: <AANLkTikMuR-KLBnYN5Utbz2MV3WRLWLYg3s4QcSkQjYd@mail.gmail.com>
Subject: Re: [PATCH] tty: avoid recursive BTM in pty_close
From: Tony Luck <tony.luck@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 11:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Call Trace:
>>  [<a0000001000159d0>] show_stack+0x50/0xa0
>>  [<a00000010090f270>] dump_stack+0x30/0x50
>>  [<a00000010008e2c0>] warn_slowpath_common+0xc0/0x120
>>  [<a00000010008e360>] warn_slowpath_null+0x40/0x60
>>  [<a00000010053eb40>] tty_open+0x160/0xc60
>>  [<a0000001001af9b0>] chrdev_open+0x310/0x360
>>  [<a0000001001a58b0>] __dentry_open+0x350/0x680
>>  [<a0000001001a5d80>] nameidata_to_filp+0x80/0xc0
>>  [<a0000001001bfee0>] finish_open+0x160/0x380
>>  [<a0000001001c0cc0>] do_last+0xbc0/0xce0
>>  [<a0000001001c5270>] do_filp_open+0x2f0/0xb40
>>  [<a0000001001a5290>] do_sys_open+0x90/0x200
>>  [<a0000001001a54d0>] sys_open+0x50/0x80
>>  [<a000000100b907e0>] kernel_init+0x340/0x420
>>  [<a000000100013c10>] kernel_thread_helper+0x30/0x60
>>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
>
> Ok, this is the same one you reported at first. I forgot to
> mention that the other patch I sent as a reply to your report
> is still needed and not yet in -next since I'm trying to
> sort through the other BKL removal patches now.
> This instance of the WARN_ON is completely harmless though,
> you could consider this one a false positive.

Quick status check. I'm still seeing these messages in next-20100628.
Are you still working on a fix?

-Tony
