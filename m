Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0GFIR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:17:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64732 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0GFIRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100706.001607.186316276.davem@davemloft.net>
References: <20100707040734.05d625af@debxo> <20100705.192221.241453945.davem@davemloft.net> 
	<AANLkTil3aZ0IF1KEc2h9MLHPZYW23pnWzEy4IiVb3zxT@mail.gmail.com> 
	<20100706.001607.186316276.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Jul 2010 02:17:32 -0600
X-Google-Sender-Auth: CMXL2nMk_P4bQ6hTnEFneTAWICw
Message-ID: <AANLkTil8dEyj5OQcpHy0HWGW_YrHCmo5CMvYx8_IL0K1@mail.gmail.com>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building code 
	out into drivers/of
To: David Miller <davem@davemloft.net>
Cc: dilinger@queued.net, devicetree-discuss@lists.ozlabs.org,
       sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org, wmb@laptop.org,
       pgf@laptop.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 1:16 AM, David Miller <davem@davemloft.net> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Tue, 6 Jul 2010 01:00:06 -0600
>
>> I'm curious... what are your plans here?  Will you be keeping OF alive
>> between kexec()?  Will the new kernel get the entire device tree from
>> fdt, or will it still be talking to OF?  How will the fdt fragments as
>> Andres described above fit into sparc kexec (as opposed to generating
>> one big tree as in his first option)?
>
> On certain sparc64 systems, I have to stop making PROM calls early
> in the boot right after I fetch the device tree into the kernel.
>
> So yes for a kexec() I'll have to pass an fdt or similar to the
> child kernel.
>
> It could be a big linear fdt buffer, or fragments, it really doesn't
> matter all that much actually.

Okay.  There is already support for getting the tree out of the kernel
and into fdt form via procfs.  Userspace can also modify it before
sending it back to kexec().  This will be easy no matter which
approach Andres uses.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
