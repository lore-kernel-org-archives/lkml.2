Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2LOTae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 14:30:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:29464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LOTad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 14:30:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,291,1355126400"; 
   d="scan'208";a="257828503"
Message-ID: <50CCCFD0.7030704@linux.intel.com>
Date: Sat, 15 Dec 2012 11:30:24 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
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
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
In-Reply-To: <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 11:57 PM, Yinghai Lu wrote:
> 
> I tailored your patch and made use 2M page increase to replace patch
> ioremap function.
> 
>    [PATCH v6 12/27] x86: use io_remap to access real_mode_data
> 
> and it will extend init_level4_pgt to map extra range. that will limit
> affect to even others.
> 
> please check if that is ok to you.
> 

What is the point of only managing 2M at a time?  Now you have to have
more conditionals and you don't get any more memory efficiency.

Filling arbitrarily into the brk is not acceptable... the brk is an O(1)
area and all brk allocations need to be reserved at compile time, so the
overflow handling is still necessary.

So no, this patch is not acceptable.

	-hpa


