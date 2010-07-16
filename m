Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0GPW26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:28:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33933 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab0GPW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:28:57 -0400
Message-ID: <4C40DD11.4020803@zytor.com>
Date: Fri, 16 Jul 2010 15:28:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
References: <20100713185816.2866.17837.stgit@localhost.localdomain> <20100713185957.2866.50995.stgit@localhost.localdomain> <20100714160704.GA10473@kryptos.osrc.amd.com> <20100714232201.00433aa9@hammerfall> <20100714233102.0f64614b@hammerfall> <4C3FDF43.6030203@zytor.com> <20100716063952.GB27546@aftab> <4C3F8418.5020803@zytor.com> <20100716072244.GA27954@aftab> <4C408298.8060004@zytor.com> <20100716162517.GF28902@aftab>
In-Reply-To: <20100716162517.GF28902@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 09:25 AM, Borislav Petkov wrote:
> 
> I don't see the need for two things denoting C1E for the very simple
> reason: when C1E gets enabled on a machine, one of the bits gets set in
> the MSR on each core simultaneously. So if one core sees one of the bits
> set, all the remaining cores are seeing them too. The first core that
> sees one of the bits in the MSR, sets c1e_detected.
> 
> So next time any core does cpu_idle() => c1e_idle(), it switches to
> timer broadcast on it since it might go into C1E if all the others
> follow.
> 
> Frankly, I can't think of a case where we'd need to two things - I
> could be missing something. But this workaround is a couple of years
> old, maybe Thomas might give us more insight into whether there's a
> particular reason for the cpuid flag and the c1e_detected variable.
> Thomas?
> 

I'm not saying there should be two things (and that's clearly wrong no
matter what), but rather it's not clear to me that the one thing should
be a variable.

	-hpa
