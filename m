Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1CAPyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:54:04 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:49447 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1CAPyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:54:03 -0500
X-Loopcount0: from 10.170.28.41
From: <Douglas_Warzecha@Dell.com>
To: <stuart_hayes@yahoo.com>, <linux-kernel@vger.kernel.org>
CC: <Shyam_Iyer@Dell.com>
Date: Tue, 1 Mar 2011 09:53:57 -0600
Subject: Re: [PATCH v2] dcdbas: force SMI to happen when expected
Thread-Topic: [PATCH v2] dcdbas: force SMI to happen when expected
Thread-Index: AcvUlKNoIc2xKIfORX2Po4At4CRJPwDk4t0Q
Message-ID: <CC13D7E3DE58AE4096779C4F1D272C8E27D8EFA445@AUSX7MCPS308.AMER.DELL.COM>
References: <518456.82543.qm@web38004.mail.mud.yahoo.com>
In-Reply-To: <518456.82543.qm@web38004.mail.mud.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 8:35 PM, Stuart Hayes wrote:
> This is a reworked version of a very similar patch I sent about three
> weeks ago... a flaw was pointed out with the original.  That patch
> didn't make it into the kernel, though, so I'm just sending this one as
> a new patch.
> 
> The dcdbas driver can do an I/O write to cause a SMI to occur.  The SMI
> handler looks at certain registers and memory locations, so the SMI
> needs to happen immediately.  On some systems I/O writes are posted,
> though, causing the SMI to happen well after the "outb" occurred, which
> causes random failures.  Following the "outb" with an "inb" forces the
> write to go through even if it is posted.
> 
> This patch is against the 2.6.37.1 kernel.
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@yahoo.com>
> ---
> 
> --- linux-2.6.37/drivers/firmware/dcdbas.c	2011-01-18
> 10:44:44.869882461 -0500
> +++ linux-2.6.37_test/drivers/firmware/dcdbas.c	2011-02-24
> 13:23:58.663771596 -0500
> @@ -268,8 +268,10 @@ int dcdbas_smi_request(struct smi_cmd *s
>  	}
> 
>  	/* generate SMI */
> +	/* inb to force posted write through and make SMI happen now */
>  	asm volatile (
> -		"outb %b0,%w1"
> +		"outb %b0,%w1\n"
> +		"inb %w1"
>  		: /* no output args */
>  		: "a" (smi_cmd->command_code),
>  		  "d" (smi_cmd->command_address),
> 

Acked-by: Doug Warzecha <douglas_warzecha@dell.com>

