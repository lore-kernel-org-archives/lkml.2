Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2LaGzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 01:55:15 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54707 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2LaGzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 01:55:14 -0500
Date: Mon, 31 Dec 2012 01:55:08 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Mihai Caraman <mihai.caraman@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1099858744.6758417.1356936908719.JavaMail.root@redhat.com>
In-Reply-To: <1155846710.6748036.1356924799341.JavaMail.root@redhat.com>
Subject: Re: kernel compilation failure on power7 system
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.37]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this as this turned out some unclean bits rendered
the result unstable. It is now passed the complication testing. 

----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "Mihai Caraman" <mihai.caraman@freescale.com>, "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
> Cc: stable@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
> Sent: Monday, December 31, 2012 11:33:19 AM
> Subject: kernel compilation failure on power7 system
> 
> Stable kernel 3.7.1 failure to compile on power7 system here,
> 
> arch/powerpc/kvm/built-in.o: In function `hdec_soon':
> /root/linux-stable/arch/powerpc/kvm/book3s_hv_rmhandlers.S:1068:
> undefined reference to `PACA_SPRG3'
> make: *** [vmlinux] Error 1
> 
> reverted this commit fixed the problem,
> -----
> 0127262c01f0beb485f917c720d1d95d165dfdbf
> [PATCH] powerpc: Restore VDSO information on critical exception om
>  BookE
> 
> Critical exception on 64-bit booke uses user-visible SPRG3 as
> scratch.
> Restore VDSO information in SPRG3 on exception prolog.
> 
> Use a common sprg3 field in PACA for all powerpc64 architectures.
> -----
> 
> Used this config - http://people.redhat.com/qcai/stable/config-ppc
> 
> system information here,
> # cat /proc/device-tree/model
> IBM,8231-E2B
> 
> CAI Qian
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
