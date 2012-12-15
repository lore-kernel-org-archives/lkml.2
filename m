Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2LOWNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:13:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48668 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LOWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:13:08 -0500
MIME-Version: 1.0
In-Reply-To: <50CCEE49.3080801@zytor.com>
References: <20121211170605.GD28827@liondog.tnic>
	<CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
	<CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
	<CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
	<50CB8213.9000908@zytor.com>
	<CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
	<CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
	<CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
	<50CCCFD0.7030704@linux.intel.com>
	<CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
	<50CCEE49.3080801@zytor.com>
Date: Sat, 15 Dec 2012 14:13:06 -0800
X-Google-Sender-Auth: hAZzn8ZXEOR57qfvgly9x2yWe5o
Message-ID: <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 1:40 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/15/2012 12:55 PM, Yinghai Lu wrote:
>> Also if we set map too large, could have chance to cover mem hole near
>> 1T for AMD HT system.
>
>
> Again, should not be cachable in the MTRRs, and even so, is 1G aligned
> already.

AMD system could have all mem between TOLM and TOHM all WB, and don
need to set them in MTRRs entries.

and also your switchover change that handle cross 1G, and 512g, and it
is not 1G aligned.
for example, if kernel at 4095G+512M, it will map from 4095G+512M to
4096G + 512M.
