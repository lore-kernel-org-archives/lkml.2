Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab0DHSzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:55:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63590 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab0DHSze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KUIfmJGgAoFwz69CR2FF70QnoNwiZEvfa55j7lKdG8iW/7/IIj2aO8QYqPahnPexu7
         cWXk62HcsPrhs92JI68SlTk9za0TNZWxjm/4gbPvUCE2mEEtxFa8hw2ibJHwR1cikDK3
         h0mRFyW1dp7yqBgc0hGUAsL7BjHf/KEZtyZ0s=
MIME-Version: 1.0
In-Reply-To: <4BBD966D.8020404@iki.fi>
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>
	 <4BBD81B3.3030500@iki.fi>
	 <20100408172316.e6ee451d.sfr@canb.auug.org.au>
	 <4BBD85ED.4090209@iki.fi>
	 <20100408174549.2f45ceea.sfr@canb.auug.org.au>
	 <4BBD966D.8020404@iki.fi>
Date: Thu, 8 Apr 2010 11:55:34 -0700
X-Google-Sender-Auth: 633c3effcfa26588
Message-ID: <o2s12c511ca1004081155o9b28c9f5hdfadd075913f1fcf@mail.gmail.com>
Subject: Re: linux-next: powerpc boot failure
From: Tony Luck <tony.luck@intel.com>
To: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing an oops in the same routine on ia64 built from next-20100408

My setup is a SLES11 installation.  next-20100407 booted with no problems.
I'm also clueless about xfrm_policy.

Here's an abbreviated copy of the first (of several) oops.  The code
dereferences a bad pointer:

Unable to handle kernel paging request at virtual address 480cb78f00000024
mount.nfs[7289]: Oops 8821862825984 [1]
Modules linked in: nfs lockd auth_rpcgss sunrpc binfmt_misc loop
dm_mod sr_mod usb_storage sg button container usbhid uhci_hcd ehci_hcd
usbcore fan processor thermal thermal_sys

Pid: 7289, CPU 16, comm:            mount.nfs
psr : 0000101008526030 ifs : 8000000000000e22 ip  :
[<a000000100888f10>]    Not tainted
(2.6.34-rc3-generic-smp-next-20100408)
ip is at __xfrm_lookup+0x650/0x760

Call Trace:
 [<a000000100015950>] show_stack+0x50/0xa0
 [<a0000001000161c0>] show_regs+0x820/0x860
 [<a00000010003ac00>] die+0x1a0/0x300
 [<a000000100068b40>] ia64_do_page_fault+0x8c0/0x9e0
 [<a00000010000bb00>] ia64_native_leave_kernel+0x0/0x270
 [<a000000100888f10>] __xfrm_lookup+0x650/0x760
 [<a0000001007ec410>] ip_route_output_flow+0xf0/0x480
 [<a000000100846c30>] ip4_datagram_connect+0x330/0x5e0
 [<a00000010085f420>] inet_dgram_connect+0x140/0x180
 [<a0000001007854f0>] sys_connect+0xf0/0x1a0
 [<a00000010000b980>] ia64_ret_from_syscall+0x0/0x20
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20

I tried the patch you just posted.  Compiling with it gave this warning:

net/xfrm/xfrm_policy.c: In function ‘__xfrm_lookup’:
net/xfrm/xfrm_policy.c:1735: warning: ‘num_xfrms’ may be used
uninitialized in this function

but the patched kernel booted ok.

-Tony
