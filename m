Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974Ab2B1SfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:35:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34773 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107Ab2B1SfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:35:11 -0500
MIME-Version: 1.0
In-Reply-To: <4F4D1857.4010706@redhat.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
 <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
 <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
 <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
 <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
 <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org>
 <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
 <4F4D0D18.4060409@redhat.com> <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com>
 <4F4D1857.4010706@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 10:34:49 -0800
X-Google-Sender-Auth: 37PwmKExgMOdskW462t9lAVureQ
Message-ID: <CA+55aFxgf_HHZKhN9FwOBgKoJHbkFzdCrPhMwWbWKXhb9NpkPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] i387: split up <asm/i387.h> into exported and
 internal interfaces
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@gmail.com>,
        Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:09 AM, Avi Kivity <avi@redhat.com> wrote:
>
> This is done by preempt notifiers.  Whenever a task switch happens we
> push the guest fpu state into memory (if loaded) and let the normal
> stuff happen.  So the if we had a task switch during instruction
> emulation, for example, then we'd get the "glacial and stupid path" to fire.

Oh christ.

This is exactly what the scheduler has ALWAYS ALREADY DONE FOR YOU.

That's what the i387 save-and-restore code is all about. What's the
advantage of just re-implementing it in non-obvious ways?

Stop doing it. You get *zero* advantages from just doing what the
scheduler natively does for you, and the scheduler does it *better*.

                   Linus
