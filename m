Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1AYRct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:32:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57690 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1AYRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mA14M4fFbL/LDKevTNW0w5Ox3Dj2eoCud2QAKbFj+ddjk1rxfeea6yLTx6NJ2oIqye
         7l8l1l9UOxtyha3Jkgb4kYYQUHpDiOxeRSPi9WZuRiBugMFfUWJz5OvsM4LQ1Y1rSk+X
         4aKH8P1FvNbkyDI5V17d4P0DixK8Hhd5Cl2Ok=
MIME-Version: 1.0
In-Reply-To: <20110125153649.GA11386@laptop>
References: <20110125134748.GA10051@laptop>
	<20110125140948.GA26762@elte.hu>
	<20110125153649.GA11386@laptop>
Date: Tue, 25 Jan 2011 09:32:47 -0800
X-Google-Sender-Auth: dxVxdM_BITpiKs9kCPDm3eZQbos
Message-ID: <AANLkTikHe8Bq1f-nv8hiAeY7rs7t5MWTvEUSYT81py4S@mail.gmail.com>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon panic
From: Tony Luck <tony.luck@intel.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 7:36 AM, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> I did not have to re-partition the box here. A kindof a hacky solution was
> disabling the swap partition and using it for storing the log. That would make
> the feature available without re-installing the box, at the cost of temporarily
> disabling swap.

Using swap space as a dump area has a long and established tradition
going back to the early roots of Unix - so I don't think that it is all that
hacky. I think that modern systems even write some magic at the start
of the swap partition that you could use to verify that you were writing to
the correct spot ... and it should be easy to retrieve your dumped data
before the swap gets re-enabled by the new kernel after the reboot.
[Perhaps the new kernel could do this automatically if it finds some
signature that your code leaves in the swap area so it could stuff the data
into my /dev/pstore filesystem?]

One more "is this bit of the BIOS code safe" concern that I have is that
you'll be using the "write" path of the INT 0x13 code ... which isn't the
path that is tested by booting ... it *ought* to be OK - but untested paths
in BIOS seem to be broken paths all too often.

-Tony
