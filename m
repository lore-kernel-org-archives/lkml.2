Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2BUV5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:57:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54274 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2BUV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:57:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.8.164 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329861273.29790.261.camel@sbsiddha-desk.sc.intel.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <1329861273.29790.261.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 13:57:31 -0800
X-Google-Sender-Auth: JeAgekTqdJRAaLXr036R3oXlmZc
Message-ID: <CA+55aFzSKR76rVAXQWjKmjmSPVu8XeULh5g864hbOgq6WA4foQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 1:54 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> Reviewing this code, I think we need to set the 'last_cpu' to an invalid
> number in the fpu_alloc too. Appended is the patch.

I cleared fpu_counter in copy_thread() instead.

Doing this in fpu_alloc() isn't necessarily a bad idea, though.

                  Linus
