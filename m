Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1DXSUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 14:20:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46802 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab1DXSUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 14:20:45 -0400
Date: Sun, 24 Apr 2011 20:20:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?Q?J=C3=B6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
Message-ID: <20110424182041.GA19984@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?Q?J=C3=B6rg-Volker?= Peetz <jvpeetz@web.de>,
	linux-kernel@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@amd.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <20110421213926.GA19721@kroah.com>
 <4DB3DA0C.1050003@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DB3DA0C.1050003@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 10:06:36AM +0200, Jörg-Volker Peetz wrote:
> With 2.6.38.4 the clock slows down and the affected laptop sometimes, e.g. for
> the output of "ps axuw" to appear, needs an input from the keyboard or the
> touchpad. Please find attached the kernel config file and the output of dmesg.
> 
> Commenting out the the lines
> 
> 	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
> 		set_cpu_cap(c, X86_FEATURE_ARAT);
> 
> in arch/x86/kernel/cpu/amd.c makes this laptop work as before with kernel
> 2.6.38.3. I think these lines came with commit
> d7b7f0c401303dd7eafcff11752fe74d3b75c766.

Hmm, interesting.

Can you send also /proc/cpuinfo please?

Looks like your CPU is a single core K8 revE or something but we'd need
the exact family info.

Thanks.

-- 
Regards/Gruss,
    Boris.
