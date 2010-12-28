Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0L1C2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 21:28:25 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35841 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822Ab0L1C2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 21:28:24 -0500
X-Sasl-enc: quJsJuqAZuNOzi6XwsZC3OYfdHHIjlsHyMTffx4yqmMo 1293503303
Date: Tue, 28 Dec 2010 00:28:20 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jj@chaosbits.net, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
Subject: Re: [tip:x86/urgent] x86/microcode: Fix double vfree() and remove
 redundant pointer checks before vfree()
Message-ID: <20101228022820.GA24251@khazad-dum.debian.net>
References: <alpine.LNX.2.00.1012251946100.10759@swampdragon.chaosbits.net>
 <tip-5cdd2de0a76d0ac47f107c8a7b32d75d25768dc1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5cdd2de0a76d0ac47f107c8a7b32d75d25768dc1@git.kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010, tip-bot for Jesper Juhl wrote:
> In arch/x86/kernel/microcode_intel.c::generic_load_microcode()
> we have  this:
> 
> 	while (leftover) {
> 		...
> 		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
> 		    microcode_sanity_check(mc) < 0) {
> 			vfree(mc);
> 			break;
> 		}
> 		...
> 	}
> 
> 	if (mc)
> 		vfree(mc);

Which is trivial to trigger from userspace, fortunately limited to root in
any sane distro (and by default).

Please send it to -stable after it gets merged in mainline and is deemed
safe...

The Intel microcode driver will also accept a bogus microcode which has a
valid header, but all zeros for the cyphertext.  This is a design defect on
the current Intel microcode format, but can be worked around by the driver
if one assumes such a cyphertext will never be valid (seems like a safe
assumption).  I sure hope the processors will reject that kind of bogosity
even if the kernel doesn't and tries to upload it, though...  I was not
crazy enough to try.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
