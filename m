Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0HRTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:09:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52202 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0HRTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:09:40 -0400
Date: Wed, 18 Aug 2010 21:09:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100818190915.GB12842@aftab>
References: <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
 <20100813123543.GC9046@aftab>
 <20100816121933.GA28147@aftab>
 <20100816123833.GB28147@aftab>
 <4C6C294D.3030404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6C294D.3030404@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Aug 18, 2010 at 02:41:17PM -0400

> On 08/16/2010 05:38 AM, Borislav Petkov wrote:
> >  #else
> >  static inline void reserve_trampoline_memory(void) {};
> > +extern void __init setup_trampoline_page_table(void) {};
> >  #endif /* CONFIG_X86_TRAMPOLINE */
> 
> This breaks compilation in the !CONFIG_X86_TRAMPOLINE case; I presume
> you meant:
> 
> static inline void setup_trampoline_page_table(void) {}
> 
> ... here too?
>
> (No semicolon after a function body!)

Yeah, thanks for catching that - this should be a static inline stub in
the !CONFIG_X86_TRAMPOLINE case.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
