Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0FXMcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:32:05 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:36479 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab0FXMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:32:01 -0400
Date: Thu, 24 Jun 2010 18:01:53 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 6/6 V4] input: STMPE touch controller support
Message-ID: <20100624123153.GB26189@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
 <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1277378021-16802-7-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 13:13:41 +0200, Luotao Fu wrote:
> +       adc_ctrl1 = SAMPLE_TIME(ts->sample_time) | MOD_12B(ts->mod_12b) |
> +               REF_SEL(ts->ref_sel);
> +       ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL1,
> +                       adc_ctrl1, adc_ctrl1);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Could not setup ADC\n");
> +               goto err_free_irq;
> +       }
> +
> +       ret = stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
> +                       ADC_FREQ(ts->adc_freq), ADC_FREQ(ts->adc_freq));
> +       if (ret) {
> +               dev_err(&pdev->dev, "Could not setup ADC\n");
> +               goto err_free_irq;
> +       }
> +
> +       tsc_cfg = AVE_CTRL(ts->ave_ctrl) | DET_DELAY(ts->touch_det_delay) |
> +                       SETTLING(ts->settling);
> +       ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_CFG, tsc_cfg, tsc_cfg);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Could not config touch\n");
> +               goto err_free_irq;
> +       }
> +
> +       ret = stmpe_set_bits(stmpe, STMPE_REG_TSC_FRACTION_Z,
> +                       FRACTION_Z(ts->fraction_z),
> +                       FRACTION_Z(ts->fraction_z));

I think your earlier revisions had this same behaviour, but this only
writes the bits you are trying to set, and it may be a problem if there
are other bits already set in this field.  I don't know if this is a
concern with this block, but if it is, you can do something like the
following to clear out the field before writing:

stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
	       ADC_FREQ(0xff), ADC_FREQ(ts->adc_freq));

or perhaps:

stmpe_set_bits(stmpe, STMPE_REG_ADC_CTRL2,
	       0xff, ADC_FREQ(ts->adc_freq));

Rabin
