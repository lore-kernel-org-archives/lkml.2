Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab0KSVlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:41:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45045 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab0KSVlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YVWz7D8xt6KCTT8hh3i/tuIBiNzy98PtQZO4Cm3TUZGHyA71eiwwpN2LjWe2hdRgxK
         MCzwghyGV9Hu6Hs86kHWLQOV8tsh0/omLfuf/Al2t1hHqwSLFxrssvJ2GQ0xsF/1aFMU
         dfuvfwnJ1N2oupHmbpiNbe2iwAqRgdI1AY5lY=
MIME-Version: 1.0
In-Reply-To: <a367bea7c1bdc198b5540b7fe3c02d10ad59cf16.1290201713.git.bengardiner@nanometrics.ca>
References: <cover.1289935504.git.bengardiner@nanometrics.ca>
	<cover.1290201713.git.bengardiner@nanometrics.ca>
	<a367bea7c1bdc198b5540b7fe3c02d10ad59cf16.1290201713.git.bengardiner@nanometrics.ca>
Date: Fri, 19 Nov 2010 15:41:11 -0600
Message-ID: <AANLkTimOByqsZjCYoz=pjwT7jcgN76Sgi4W6SFJ9+N-d@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] da850-evm: extract defines for SEL{A, B, C} pins
 in UI expander
From: Victor Rodriguez <vm.rod25@gmail.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 3:37 PM, Ben Gardiner
<bengardiner@nanometrics.ca> wrote:
> The setup and teardown methods of the UI expander reference the SEL_{A,B,C}
> pins by 'magic number' in each function. This uses the common enum for their offsets
> in the expander setup and teardown functions.
>
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>
> ---
>
> Changes since v2:
>  * rebased to 083eae3e28643e0eefc5243719f8b1572cf98299 of
>   git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
>  * integrated the static array initialization patch provided by Sekhar Nori
>
> Changes since v1:
>  * No changes since v1
>
> ---

I think that ther must be just one   --- , This is extra

Regards

Victor Rodriguez

>  arch/arm/mach-davinci/board-da850-evm.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index b0763f7..c689e7e 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -361,23 +361,23 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
>  {
>        int sel_a, sel_b, sel_c, ret;
>
> -       sel_a = gpio + 7;
> -       sel_b = gpio + 6;
> -       sel_c = gpio + 5;
> +       sel_a = gpio + DA850_EVM_UI_EXP_SEL_A;
> +       sel_b = gpio + DA850_EVM_UI_EXP_SEL_B;
> +       sel_c = gpio + DA850_EVM_UI_EXP_SEL_C;
>
> -       ret = gpio_request(sel_a, "sel_a");
> +       ret = gpio_request(sel_a, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_A]);
>        if (ret) {
>                pr_warning("Cannot open UI expander pin %d\n", sel_a);
>                goto exp_setup_sela_fail;
>        }
>
> -       ret = gpio_request(sel_b, "sel_b");
> +       ret = gpio_request(sel_b, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_B]);
>        if (ret) {
>                pr_warning("Cannot open UI expander pin %d\n", sel_b);
>                goto exp_setup_selb_fail;
>        }
>
> -       ret = gpio_request(sel_c, "sel_c");
> +       ret = gpio_request(sel_c, da850_evm_ui_exp[DA850_EVM_UI_EXP_SEL_C]);
>        if (ret) {
>                pr_warning("Cannot open UI expander pin %d\n", sel_c);
>                goto exp_setup_selc_fail;
> @@ -420,13 +420,13 @@ static int da850_evm_ui_expander_teardown(struct i2c_client *client,
>        platform_device_unregister(&da850_evm_ui_keys_device);
>
>        /* deselect all functionalities */
> -       gpio_set_value_cansleep(gpio + 5, 1);
> -       gpio_set_value_cansleep(gpio + 6, 1);
> -       gpio_set_value_cansleep(gpio + 7, 1);
> +       gpio_set_value_cansleep(gpio + DA850_EVM_UI_EXP_SEL_C, 1);
> +       gpio_set_value_cansleep(gpio + DA850_EVM_UI_EXP_SEL_B, 1);
> +       gpio_set_value_cansleep(gpio + DA850_EVM_UI_EXP_SEL_A, 1);
>
> -       gpio_free(gpio + 5);
> -       gpio_free(gpio + 6);
> -       gpio_free(gpio + 7);
> +       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_C);
> +       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_B);
> +       gpio_free(gpio + DA850_EVM_UI_EXP_SEL_A);
>
>        return 0;
>  }
> --
> 1.7.0.4
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
>
