Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1AIRY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:24:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61851 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1AIRY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hSEZLg5eGEpqWtExhM5ugNmJgGthw9wOEXJpe60sCV9BldxSESZ6Rw+TorjEW3ZNM5
         AYrqOu6p31msBXHKuA9JxHi8B8fhI7yumNo0+RsYWjWW+YyNu4WMUSU7Kr+s1dHCoRD0
         /+OglwlUbs9FKcQp8iI9Ky+VwEodAhWwxR5QI=
MIME-Version: 1.0
In-Reply-To: <20110109093926.GB542@elte.hu>
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
	<20110109093926.GB542@elte.hu>
Date: Sun, 9 Jan 2011 22:57:01 +0600
Message-ID: <AANLkTik=bg0KY8Oygxem+SdEaPHwBtHRHOcz29HSReHH@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 3:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hm, what effects does this have in practice? smpboot.c uses disabled_cpus as a value
> to calculate limits - why has this bug not caused some misbehavior somewhere? (or if
> it has caused misbehavior, what is that?)

If I'm not wrong, smpboot.c tries to get the possible cpu map by
calculating disabled_cpus and num_processors. When we pass nr_cpus=n,
which is less than no. of CPUs available, we can't put more CPUs
online. So, no of cpu we detect at startup is okay. Or am I missing
anything?

thanks,
rakib

>
> Thanks,
>
>        Ingo
>
