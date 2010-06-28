Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0F1AOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 20:14:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36971 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0F1AOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 20:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GPsXHnZgttPjf/8flMwz87zf+yFV4T1+w2C5gxCOczuRF9J9JuwJOHGx3KykF68D2B
         j6dRr2gA813s/Xl8c4VywIjXc9M51s79132+RGdsSigkz18sacFwtnnF4ap0NOWaYJ8f
         I1Ml8AM+ddNlCBe9Syw+k4nQMd4UNaHfqFQXI=
Message-ID: <4C27E965.80508@gmail.com>
Date: Sun, 27 Jun 2010 18:14:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: lenb@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1277673679-21458-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2010 03:21 PM, Jiri Slaby wrote:
> On IBM Bartolo machines, cards in 00:09.0 are defunct (if use
> interrupts). DSDT says that this slot (with function 0, i.e. pin A) is
> routed to \_SB_.PCI0.PIB_.LNKB. But it's not, it's wired to LNKC, so
> interrupts are misrouted. Add a quirk for this to workaround the
> issue.

That seems a rather serious DSDT flaw. Do devices in that slot work in 
Windows?

>
> This error was reported in suse bugzilla at:
> https://bugzilla.novell.com/show_bug.cgi?id=595683

Apparently that bugzilla requires a login to even view the bug, seems 
bizarre to me..

>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Len Brown<lenb@kernel.org>
> Cc: Jesse Barnes<jbarnes@virtuousgeek.org>
> ---
>   drivers/acpi/pci_irq.c |   15 +++++++++++++++
>   1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index e4804fb..8e054a4 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -125,6 +125,18 @@ static const struct dmi_system_id hp_t5710[] = {
>   	{ }
>   };
>
> +/* https://bugzilla.novell.com/show_bug.cgi?id=595683 */
> +static const struct dmi_system_id ibm_bartolo[] = {
> +	{
> +		.ident = "IBM Bartolo",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "IBM CORPORATION"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "4810320"),
> +		},
> +	},
> +	{ }
> +};
> +
>   struct prt_quirk {
>   	const struct dmi_system_id *system;
>   	unsigned int		segment;
> @@ -152,6 +164,9 @@ static const struct prt_quirk prt_quirks[] = {
>   	{ hp_t5710, 0, 0, 1, PCI_INTX_PIN('A'),
>   		"\\_SB_.PCI0.LNK1",
>   		"\\_SB_.PCI0.LNK3"},
> +	{ ibm_bartolo, 0, 0, 9, PCI_INTX_PIN('A'),
> +		"\\_SB_.PCI0.PIB_.LNKB",
> +		"\\_SB_.PCI0.PIB_.LNKC"},
>   };
>
>   static void do_prt_fixups(struct acpi_prt_entry *entry,

