Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab2DTE4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 00:56:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab2DTE4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 00:56:41 -0400
Message-ID: <4F90EC19.7070103@zytor.com>
Date: Thu, 19 Apr 2012 21:54:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <david.s.daney@gmail.com>, David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v1 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com> <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com> <4F90BF8D.7030209@zytor.com> <4F90D564.3090508@gmail.com> <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com> <4F90DB37.9080702@zytor.com> <4F90EAC1.6070508@zytor.com>
In-Reply-To: <4F90EAC1.6070508@zytor.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 09:49 PM, H. Peter Anvin wrote:
> 
> Ah, apparently it is possible to generate relocations relative to the
> start of the current section.
> 

Nevermind... I'm wrong.  The assembler will generate them but the linker
will produce garbage.

So I think using PC-relative relocations and have the postprocessor (or
the sort in the module loader) convert them to section-relative makes
sense...

	-hpa
