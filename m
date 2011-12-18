Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1LRIiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:38:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1LRIiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:38:06 -0500
Date: Sun, 18 Dec 2011 09:36:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Michael Demeter <michael.demeter@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] Added some addition debug prints for pb_keys
Message-ID: <20111218083614.GF4144@elte.hu>
References: <20111215223116.10166.50803.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215223116.10166.50803.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Michael Demeter <michael.demeter@intel.com>
> 
> Added additional debug output that we always seem to add
> during power ons to validate firmware operation.
> 
> Signed-off-by: Michael Demeter <michael.demeter@intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  arch/x86/platform/mrst/mrst.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
> index a9a4732..3002cc86 100644
> --- a/arch/x86/platform/mrst/mrst.c
> +++ b/arch/x86/platform/mrst/mrst.c
> @@ -1035,6 +1035,8 @@ static int __init pb_keys_init(void)
>  	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
>  	for (i = 0; i < num; i++) {
>  		gb[i].gpio = get_gpio_by_name(gb[i].desc);
> +		pr_debug("info[%2d]: name = %s,"
> +				"gpio = %d\n", i, gb[i].desc, gb[i].gpio);

I've fixed this to lie on a single line - there's no point in 
line-breaking pr_debug()s in general - especially not the format 
string.

Note that merging the format string unearthed a small formatting 
ugly:

	"info[%2d]: name = %s,gpio = %d\n"

I edited that to the probably intended:

	"info[%2d]: name = %s, gpio = %d\n"

Thanks,

	Ingo
