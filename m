Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0JMBrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 21:47:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2834 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab0JMBry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 21:47:54 -0400
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
From: Joe Perches <joe@perches.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 18:47:52 -0700
Message-ID: <1286934472.1117.129.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 18:20 -0700, Peter Hsiang wrote:
> This patch adds the MAX98088 CODEC driver.

Just trivial comments:

> +static struct {
> +       int readable;
> +       int writable;
> +       int vol;
> +} max98088_access[M98088_REG_CNT] = {

bool instead?

static struct {
	bool readable;
	bool writable,
	bool vol;
} etc...

readable isn't used anywhere, writeable is used as bool
vol isn't a good name as it's easy to confuse with
volume.  Maybe volatile_register?

> +static int max98088_volatile_register(unsigned int reg)
> +{
> +       return max98088_access[reg].vol;
> +}

No error checking if reg isn't limited to the array size.

> +static const char *max98088_exmode_texts[] = {
[]
> +static const char *max98088_ex_thresh[] = { /* volts PP */
[]
> +static const struct soc_enum max98088_ex_thresh_enum[] = {
[]
> +static const char *max98088_fltr_mode[] = {"Voice", "Music" };
[]
> +static const char *max98088_extmic_text[] = { "None", "MIC1", "MIC2" };
[]
> +static const char *max98088_dai1_fltr[] = {

static const char * const


