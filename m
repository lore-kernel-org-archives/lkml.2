Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1JLTS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:18:26 -0400
Received: from claw.goop.org ([74.207.240.146]:46404 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1JLTSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:18:25 -0400
Message-ID: <4E95E7FE.6050302@goop.org>
Date: Wed, 12 Oct 2011 12:18:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>, the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com>
In-Reply-To: <4E95D9E7.6090304@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 11:18 AM, H. Peter Anvin wrote:
> On 10/12/2011 03:16 AM, Borislav Petkov wrote:
>> Why would a xen microcode solution would even be contingent on how
>> upstream Linux solves it (and when)?
>>
> Agreed... especially since Xen is "special" when it comes to booting anyway.

"Special" only in the sense that you need a new line in grub.

But doing boot-time microcode is a lot more "special" since it would
require distros to move the microcode files to /boot.  That would either
mean having two sets of microcode packages, or also changing the way
that Linux does its microcode loading (if only by changing the paths,
but I have no idea what that implies since its all tied up with the rest
of the firmware loading stuff).

The whole thrust of the Xen upstreaming work has been to minimize the
amount of arbitrary "specialness" so that its as easy as possibly for
people and distros to deploy and use Xen.

With respect to microcode loading, this patch means that users and
distros just don't need to worry about microcode any more.  It packages
and operates exactly like it would for native Linux, which is exactly
how we like it.

While doing the whole boot time multiboot thing may offer some small
hypothetical technical advantages, it has the significant cost of just
complicating the whole deployment and use story.

If there were a general shift to "this is how we're going to do
microcode in the future", then Xen will happily go along for the ride. 
But for right now, this patch seems like the pragmatic solution.

I think the real question is where there's something objectionable about
the patch itself?

Thanks,
    J
