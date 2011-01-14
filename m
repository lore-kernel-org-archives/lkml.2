Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1ANJrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:47:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38203 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1ANJrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:47:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ZLNUP5Ez5cxCLiMMJ3/nC8ZEsGKde/ZGj442upDSBcyGKHe4X3G2kwnhfEBQSBCB1b
         UsWkfVhONC328vey3ZQ4Ebq3gjhhZqFGq4P2phRx8B+wtSkp9pLcajw7x+s+95aqL5OY
         TEKNg0VEyqb8mhzubcnDVipFHhpHhCJ9nkyuc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
	<8952.1294927845@jrobl>
	<alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
	<AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com>
	<alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
Date: Fri, 14 Jan 2011 10:47:00 +0100
Message-ID: <AANLkTinYTitBfY-HFrND5pJH_YcYAtMfLJ-eL1y542WM@mail.gmail.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 14 Jan 2011, Nick Piggin wrote:
>
>> On Fri, Jan 14, 2011 at 3:41 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 13 Jan 2011, J. R. Okajima wrote:
>> >> Thomas Gleixner:
>> >> > The dcache scalability work broke NFS root filesystems.
>> >>       :::
>> >> > Check for parent equal dentry and skip the nested lock to avoid the
>> >> > deadlock. I'm sure this is the wrong fix, but at least it "works" :)
>> >>
>> >> With this patch, can you unmount it cleanly?
>> >> It skips incrementing d_count for both dentries.
>> >> Do we need at least one?
>> >
>>
>> Yeah thanks everyone for reporting this.
>>
>> I have a fix for it in a slightly different way, and a couple of other reported
>> bugs, which are going through stress testing now.
>
> Can you point us to the patches, so we can run our own set of
> tests in paralell?
>
> Thanks,
>
>        tglx

I guess several mentionned patches are now in [1] and I am testing
them against linux-next (next-20110114).

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=shortlog;h=refs/heads/vfs-scale-working
