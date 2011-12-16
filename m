Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab1LPCM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:12:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37187 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LPCM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:12:56 -0500
Date: Fri, 16 Dec 2011 03:12:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111216021254.GG14839@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-8-git-send-email-andi@firstfloor.org> <20111208084958.GA23245@gere.osrc.amd.com> <20111208143725.GD24062@one.firstfloor.org> <4EEA9CB2.9020709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEA9CB2.9020709@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 05:19:46PM -0800, H. Peter Anvin wrote:
> On 12/08/2011 06:37 AM, Andi Kleen wrote:
> >> Well, there is CPUID_8000_0007_EDX[7] which denotes the presence
> >> of the P-state registers. It probably could be added to
> >> init_scattered_cpuid_features() but there's still special handling
> >> needed for K8.
> > 
> > Dave is probably right that it's not worth moving the list.
> > 
> >> Can you do both a family and a feature bit test with the autoprobing
> >> code?
> > 
> 
> Another similar question: is it possible to key a load on more than one
> CPU feature?  It's fairly common that you need more than one feature for
> a specific piece of code to function, and it would be good to be able to
> represent it.

Right now it's not possible. The driver just errors out if it can't
find some additional capability.

I considered it originally, but all the cases I looked at were quite 
obscure (unlikely to happen) so I opted for this simpler setup.

-Andi
