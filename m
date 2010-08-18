Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0HRRq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:46:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57864 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0HRRqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:46:23 -0400
Message-ID: <4C6C1C19.2070704@zytor.com>
Date: Wed, 18 Aug 2010 10:44:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Alok Kataria <akataria@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
References: <1281986754.23253.32.camel@ank32.eng.vmware.com> <4C69D02F.6090601@zytor.com> <1282024311.20786.2.camel@ank32.eng.vmware.com> <4C6A2C98.4060605@zytor.com> <20100817070520.GD32714@liondog.tnic> <1282063532.4388.8.camel@ank32.eng.vmware.com> <20100817185634.GA10597@liondog.tnic> <20100818161639.GF9880@aftab> <4C6C08EC.2080404@zytor.com> <20100818173401.GG9880@aftab>
In-Reply-To: <20100818173401.GG9880@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 10:34 AM, Borislav Petkov wrote:
> 
> Right, do you have strong preferences between x86_init and x86_platform?
> The version below uses x86_platform because it has the calibrate_tsc()
> function in there too. Also, the version below nicely moves all that
> AMD-specific code to cpu/amd.c.
> 

x86_init if it is expected to be __init code, otherwise x86_platform.

> I didn't opt for a calibrate_cpu_noop stub because I didn't want to
> pollute x86_init.c with yet another noop prototype. But I guess I should
> do that since the pointer testing is still executed while stubs are
> removed completely by smart compilers :).

Don't think it matters much, but tglx might have an opinion.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

