Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2C3HLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:11:33 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:41706 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755060Ab2C3HL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:11:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20120329164828.GD21579@dhcp-26-207.brq.redhat.com>
Date: Fri, 30 Mar 2012 00:15:05 -0700
In-Reply-To: <20120329164828.GD21579@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Thu, 29 Mar 2012 18:48:32 +0200")
Message-ID: <m17gy2mufa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18fcpgZv1Ab/zzu565GoFTwxEl8n3/PiBE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Gordeev <agordeev@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] x86, acpi/irq: Minor readability cleanup of gsi_to_irq()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> Init value of 'irq' variable is never used. So do not initialize it.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---

Looks good to me.    I was going to ask what idiot wrote that silly
thing but it appears that idiot was me.    I must have rewritten
the function and forgotten to cleanup that initial assignment to irq.

That change makes it much clearer what is going on thank you.

Eric

>  arch/x86/kernel/acpi/boot.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 406ed77..f148557 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -103,13 +103,11 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
>  
>  static unsigned int gsi_to_irq(unsigned int gsi)
>  {
> -	unsigned int irq = gsi + NR_IRQS_LEGACY;
> -	unsigned int i;
> +	unsigned int irq;
>  
> -	for (i = 0; i < NR_IRQS_LEGACY; i++) {
> -		if (isa_irq_to_gsi[i] == gsi) {
> -			return i;
> -		}
> +	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
> +		if (isa_irq_to_gsi[irq] == gsi)
> +			return irq;
>  	}
>  
>  	/* Provide an identity mapping of gsi == irq
