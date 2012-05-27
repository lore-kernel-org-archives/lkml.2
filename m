Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2E0PEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 11:04:39 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:21195 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2E0PEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 11:04:35 -0400
Date: Sun, 27 May 2012 17:04:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ilya Malakhov <ilmalakhovthefirst@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: Re: Sparc32: BTFIXUPSET_CALL(pmd_clear, . . .)-related issue in
	older versions of the kernel
Message-ID: <20120527150433.GA19538@merkur.ravnborg.org>
References: <CAK1sNPDMcX=D+=1uxVpX5HOgKyCzXr1EeUx7Eyky2j-2n3q0Ng@mail.gmail.com> <CAK1sNPDNz3E3PLq4mB6VagWu0BsGdhQVcew2YDmaG+JJBup3ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK1sNPDNz3E3PLq4mB6VagWu0BsGdhQVcew2YDmaG+JJBup3ug@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilya.

Cc: sparclinux + David S. Miller.

On Sun, May 27, 2012 at 04:03:50PM +0400, Ilya Malakhov wrote:
>  Hi.
> 
>  While analyzing a rather nasty problem with an application running at
> sun4m sparc32 hosts with "Fujitsu TurboSparc" and "TI Viking/MXCC"
> MMUs, I realized, that as a 4Kb "Page Table" was freed, only the first
> element in the corresponding `pmdv[]' array in
> 
> typedef struct { unsigned long pmdv[16]; } pmd_t;
> 
> was actually cleared, rather than all the 16 ones.
> 
>  The reason for that was the use of `BTFIXUPCALL_SWAPO0G0' instead of
> `BTFIXUPCALL_NORM' for `pmd_clear' in case of "default" SRMMU (except
> for some specific types of SRMMU) during initialization:
>  . .
> BTFIXUPSET_CALL(pmd_clear, srmmu_pmd_clear, BTFIXUPCALL_SWAPO0G0);
>  . .
> 
>  That would probably be OK if pmd_t were `struct { unsigned long pmd;
> }' as it used to be ten years ago, but seems to be erroneous nowadays,
> doesn't it?
> 
>  From a user's point of view this leads to poorly diagnosable
> problems. E.g., after a series of mmaps and munmaps one may find
> himself in a situation, where different virtual addresses are mapped to
> the same physical one.
> 
Sounds like a problem that have taken long time to track down!

>  A recent commit by David Miller, where pmd_clear() is un-btfixupped,
> is likely to solve this problem in future versions of the kernel.
We were very glad to kill off this btfixup thing.


> I wonder, if any patches for older ones should be expected.

If someone submits a patch for this it is likely to happen - hint!
That patch should explicit reference the commit in upstrem
that fixes the same bug.

Otherwise - no.

	Sam
