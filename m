Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab0HEQaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:30:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50861 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab0HEQaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100803114853.27a29365.sfr@canb.auug.org.au>
References: <20100803114853.27a29365.sfr@canb.auug.org.au>
Date: Thu, 5 Aug 2010 09:30:15 -0700
Message-ID: <AANLkTimMLts_x_BujsqYupkmA-UyB9mNyD6KZ0OeNRWd@mail.gmail.com>
Subject: Re: linux-next: manual merge of the davinci tree with Linus' tree
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 6:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Kevin,
>
> Today's linux-next merge of the davinci tree got a conflict in
> arch/arm/mach-davinci/board-da850-evm.c between commit
> 8b24599e72c9aee1ea1187e29cb9c5de9f449cce ("davinci: da850/omap-l138 evm:
> account for DEFDCDC{2,3} being tied high") from Linus' tree and commit
> ebd1e7808b2fe72d627bdab7bcf61126a831ca5a ("davinci: da850 evm: sparse
> cleanup: make file local variables static") from the davinci tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

Thanks for catching this.

Before I submit to Linus, I'll merge this with the original tree
(Liam's voltage-2.6 tree) so Linus doesn't have to fix this up.

Kevin

> diff --cc arch/arm/mach-davinci/board-da850-evm.c
> index b280efb,f6942dd..0000000
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@@ -470,12 -469,7 +470,12 @@@ static struct regulator_consumer_suppl
>        },
>  };
>
>  +/* We take advantage of the fact that both defdcdc{2,3} are tied high */
>  +static struct tps6507x_reg_platform_data tps6507x_platform_data = {
>  +      .defdcdc_default = true,
>  +};
>  +
> - struct regulator_init_data tps65070_regulator_data[] = {
> + static struct regulator_init_data tps65070_regulator_data[] = {
>        /* dcdc1 */
>        {
>                .constraints = {
>
