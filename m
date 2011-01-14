Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1ANBCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:02:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32861 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1ANBCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sRt0r3sJYWgiIkUob/d9OqeNwm4g/BemM0aQGE/tUNkEJnO8bzR11Nb7J2UeHRZJby
         6Kv1pBe+K75fdi23/lmQHiSyJDMa9Q0YVjAoVKiI6N5qNz/S6f2ZEceRqiQGRWq+O/2b
         E8a1tPrzlUlQDLr92yuiV5F9xsiThYzAtwT5Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
	<8952.1294927845@jrobl>
	<alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
Date: Fri, 14 Jan 2011 12:01:58 +1100
Message-ID: <AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
From: Nick Piggin <npiggin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 3:41 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 13 Jan 2011, J. R. Okajima wrote:
>> Thomas Gleixner:
>> > The dcache scalability work broke NFS root filesystems.
>>       :::
>> > Check for parent equal dentry and skip the nested lock to avoid the
>> > deadlock. I'm sure this is the wrong fix, but at least it "works" :)
>>
>> With this patch, can you unmount it cleanly?
>> It skips incrementing d_count for both dentries.
>> Do we need at least one?
>

Yeah thanks everyone for reporting this.

I have a fix for it in a slightly different way, and a couple of other reported
bugs, which are going through stress testing now.

Thanks,
Nick
