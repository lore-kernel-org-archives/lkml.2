Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2EWQpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:45:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53207 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2EWQpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FBD1365.4090800@zytor.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com> <CA+55aFx9pgAQEFuNyANpHA6OcBL8LyHwknPUOb4=ysjYd4cnwQ@mail.gmail.com>
 <4FBD1365.4090800@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:45:18 -0700
X-Google-Sender-Auth: 6rdSTs05j1dQiQ8sKhdohTYFRjI
Message-ID: <CA+55aFxGY4fLa_ovp7b_ZRCrBEPfNH6MxUS3eaWAKo01iq8DLA@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:42 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/23/2012 09:40 AM, Linus Torvalds wrote:
>
> And it doesn't work in assembly.  However, I really question the assumption.

The asm case is *trivial*.

asm cannot handle anything but constant shifts anyway, so the BIT()
constness rules would remain. But since asm doesn't have any integer
types, you simply do

  #ifdef __ASSEMBLY__
    #define BIT(x) (1<<(x))
  #else
    .. the C type-morphing one ..
  #endif

As to questioning the assumption, you're simply wrong. BIT(0)
absolutely MUST NOT be a 64-bit value on a 32-bit kernel. End of
discussion. This isn't an "assumption", it's an axiom.

                    Linus
