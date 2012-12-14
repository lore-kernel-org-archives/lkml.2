Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2LNUxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:53:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50168 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab2LNUxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:53:32 -0500
Message-ID: <50CB9172.8060801@zytor.com>
Date: Fri, 14 Dec 2012 12:52:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com> <50CB8213.9000908@zytor.com> <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com> <1bdaf70f-7271-4aed-a985-0b455ccafab1@email.android.com> <CAE9FiQXf8eq=zwoSPvN4oBuRShirS57STFuPTNcKm7Gf+Bs2Vg@mail.gmail.com>
In-Reply-To: <CAE9FiQXf8eq=zwoSPvN4oBuRShirS57STFuPTNcKm7Gf+Bs2Vg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:17 PM, Yinghai Lu wrote:
> On Fri, Dec 14, 2012 at 12:10 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> What info are you referring to?
> 
> pointer to init_level4_pgt page.
> 

We point the trampoline at the proper page tables in swapper_pg_dir;
this means pushing realmode initialization (but not reservation!) after
pagetable_init(), but that should be fine I *believe*... the big
question is if we have something that wants to invoke EFI before then,
if so it could get tricky.

	-hpa

