Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1HINJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:09:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53469 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1HINJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110809135050.79eed316@lxorguk.ukuu.org.uk>
References: <cover.1312893572.git.luto@mit.edu> <20110809135050.79eed316@lxorguk.ukuu.org.uk>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 09:09:34 -0400
X-Google-Sender-Auth: 6MXMwRAS4aqRNhz3XIIGLsj9wvg
Message-ID: <CAObL_7G5j-8dmQDc2Q+matB8nHk7421CWnBHqQs9-T2fjVecng@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Forcibly enable some MISC_ENABLE features on Intel
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 8:50 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue,  9 Aug 2011 08:41:04 -0400
> Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> Intel allows BIOS or the OS to enable or disable some CPU fueatures via
>> IA32_MISC_ENABLE.  I have machines that don't enable fast strings or
>> monitor/mwait in BIOS, so do it on bootup instead.
>
> The question is - why.
>
>> The Intel SDM volume 3, appendix B.1 says that the OS should not touch
>> the monitor enable bit if SSE3 is not present, which presumably means
>> that the OS may touch that bit if SSE3 is present.  In any case, these
>> patches seem to work.
>
> That's a big "presumes"
>
> For example back in Pentium days the BIOS sometimes turned off a string
> fast path because it was subtly not reliable on certain parts and could
> corrupt.
>
> It's possible your BIOS vendor has a good reason for doing this. It's
> also possible its a bug, or a left over perhaps from some pre-release
> processor or something.

Intel also says:

  However, Intel recomments that system software always enable
  fast-string operation.

On my machine it's definitely a bug.  It's a Sandy Bridge box (from
Intel) and with TXT disabled the BIOS enables fast strings on its own.

Fenghua, do you know if there are any machines that will pass the
version checks and will actually allow fast strings to be enabled but
that will have problems as a result?

If we want to be conservative, we could limit it to the most recent
family 6 devices and exclude family 0xf entirely.

--Andy
