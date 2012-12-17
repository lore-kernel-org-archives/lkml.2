Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2LQXNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:13:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2LQXNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:13:10 -0500
Message-ID: <50CFA6A4.7010805@zytor.com>
Date: Mon, 17 Dec 2012 15:11:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com> <50CCCFD0.7030704@linux.intel.com> <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com> <50CCEE49.3080801@zytor.com> <CAE9FiQV6tmHqnwOX8Rh3heaG1PQ9YQNN45esMQjqZP8Upw0Y-g@mail.gmail.com> <CAE9FiQUSve-5zuD8JyOK-eeJwTu6-E7ZnYCvc74jPVWwxhLP4g@mail.gmail.com> <CAE9FiQUWFaOkLNc8fJw=bEUwOkusadriMn0Oajk+F64vo5Eysw@mail.gmail.com> <CAE9FiQVG1WvtoUNK3ecfmSCocJZt694yrm7=iaOciD47GN=9EA@mail.gmail.com>
In-Reply-To: <CAE9FiQVG1WvtoUNK3ecfmSCocJZt694yrm7=iaOciD47GN=9EA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 02:47 PM, Yinghai Lu wrote:
>
> Peter, can you check that branch again?
>
> I moved the early_trap_init after init_mem_mapping.
> so for 64bit native, init_mem_mapping will setup page table for ram from blank.
>

Looks better, at first glance at least.  There are a couple of 
unnecessary changes (the counter in head_64.S cannot exceed 32 bits once 
computed, so the change from %rcx to %ecx change is pointless.)

There is another bug in my patch: it either needs to mask off the NX bit 
if we are running on non-NX-enabled hardware, or it needs to not set the 
NX bit (which is mostly okay that early on, I suspect.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

