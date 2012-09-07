Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2IGR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:57:29 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:13569 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402Ab2IGR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:57:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19YHSihLYRvsaKvVsmi4Doc
Date: Fri, 7 Sep 2012 10:57:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH] serial: omap: fix compile breakage
Message-ID: <20120907175721.GD1303@atomide.com>
References: <20120907153136.GA8634@kroah.com>
 <1347032059-8901-1-git-send-email-balbi@ti.com>
 <20120907154008.GA21216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907154008.GA21216@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@linuxfoundation.org> [120907 08:43]:
> On Fri, Sep 07, 2012 at 06:34:19PM +0300, Felipe Balbi wrote:
> > when rebasing patches on top of Greg's tty-next,
> > it looks like automerge broke a few things which
> > I didn't catch (for whatever reason I didn't
> > have OMAP Serial enabled on .config) so I ended
> > up breaking the build on Greg's tty-next branch.
> > 
> > Fix the breakage by re-adding the three missing
> > members on struct uart_omap_port.
> > 
> > Reported-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> > 
> > Hi Greg,
> > 
> > I just fetched your tree again and rebased again just to
> > make sure. Everything is fine here, let me know if it
> > still applies with fuzz.
> 
> That worked, thanks.

Something is still wrong with omap-serial in tty-next. It now
compiles and works for the legacy non-devicetree case, but with
device tree booting there's now regression during boot:

[    5.200836] Freeing init memory: 332K
[    6.881744] Unable to handle kernel NULL pointer dereference at virtual address 00000030
[    6.890258] pgd = ee664000
[    6.893096] [00000030] *pgd=ae64f831, *pte=00000000, *ppte=00000000
[    6.899688] Internal error: Oops: 17 [#1] SMP ARM
[    6.904632] Modules linked in:
[    6.907836] CPU: 1    Not tainted  (3.6.0-rc4-00207-gc893c8c-dirty #485)
[    6.914916] PC is at serial_omap_start_tx+0x60/0x98
[    6.920043] LR is at serial_omap_start_tx+0x44/0x98
[    6.925140] pc : [<c0316978>]    lr : [<c031695c>]    psr: 60000193
[    6.925140] sp : ee661e80  ip : 00000060  fp : a0000113
[    6.937194] r10: ef3c0010  r9 : ee798800  r8 : 00000072
[    6.942687] r7 : ef3d7472  r6 : 00000002  r5 : 00000007  r4 : ef3c0010
[    6.949523] r3 : 00000000  r2 : 00000004  r1 : 00000007  r0 : ef0da008
[    6.956390] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    6.963958] Control: 10c53c7d  Table: ae66404a  DAC: 00000015
[    6.970001] Process modprobe (pid: 715, stack limit = 0xee6602f8)
[    6.976379] Stack: (0xee661e80 to 0xee662000)
[    6.980957] 1e80: ee798800 ef3c0010 20000113 c030fcb4 00000000 ef3eead0 00000000 c0310544
[    6.989562] 1ea0: ef3eead0 ee798800 00000fff 00000073 ee798d94 ef3d7400 ee660000 ee7989b8
[    6.998138] 1ec0: ef3d7400 c02fa090 00000073 ef3d7400 ee798800 ee798800 ef0ccdc0 c02fb8e4
[    7.006713] 1ee0: beaa07bc ee798a2c beaa07bc 00000000 ef38aa00 c00778a0 ee798a4c ee798a4c
[    7.015319] 1f00: ee798d4c ef0ccdc0 00000073 00000073 ee798800 b6f19000 ee660000 00000400
[    7.023895] 1f20: 00000000 c02f775c c02fb7a8 ef1f6840 ee661f80 ef0ccdc0 00000000 ef0ccdc0
[    7.032470] 1f40: 00000073 b6f19000 ee661f80 00000073 ee660000 00000000 beaa07bc c010b580
[    7.041046] 1f60: ef38aa00 00000001 00000000 00000000 ef0ccdc0 b6f19000 00000073 c010b6e4
[    7.049652] 1f80: 00000000 00000000 beaa0888 00000000 00000073 beaa0888 00000073 00000004
[    7.058227] 1fa0: c0014308 c0014160 00000073 beaa0888 00000000 b6f19000 00000073 00000000
[    7.066802] 1fc0: 00000073 beaa0888 00000073 00000004 b6f19000 00000000 b6ee271d beaa07bc
[    7.075408] 1fe0: 00000000 beaa01c0 b6e2c874 b6e8015c 60000110 00000000 aaaaaaaa aaeaaaaa
[    7.083984] [<c0316978>] (serial_omap_start_tx+0x60/0x98) from [<c030fcb4>] (uart_start+0x68/0x6c)
[    7.093414] [<c030fcb4>] (uart_start+0x68/0x6c) from [<c0310544>] (uart_write+0xcc/0xf4)
[    7.101928] [<c0310544>] (uart_write+0xcc/0xf4) from [<c02fa090>] (process_output_block+0xc0/0x17c)
[    7.111419] [<c02fa090>] (process_output_block+0xc0/0x17c) from [<c02fb8e4>] (n_tty_write+0x13c/0x2ac)
[    7.121215] [<c02fb8e4>] (n_tty_write+0x13c/0x2ac) from [<c02f775c>] (tty_write+0x13c/0x228)
[    7.130065] [<c02f775c>] (tty_write+0x13c/0x228) from [<c010b580>] (vfs_write+0xb0/0x144)
[    7.138671] [<c010b580>] (vfs_write+0xb0/0x144) from [<c010b6e4>] (sys_write+0x40/0x70)
[    7.147094] [<c010b6e4>] (sys_write+0x40/0x70) from [<c0014160>] (ret_fast_syscall+0x0/0x3c)
[    7.155944] Code: e6ff1075 e18310b2 e5940180 e5903084 (e5933030) 
[    7.162353] ---[ end trace 8cfe94e3de797bda ]---

