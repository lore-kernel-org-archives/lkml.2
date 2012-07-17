Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2GQGkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:40:06 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56522 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab2GQGkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:40:01 -0400
Message-ID: <500508B0.9010009@st.com>
Date: Tue, 17 Jul 2012 12:09:44 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 1/2] MFD: twl6040: Fix revision information
References: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com> <1342432184-12046-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1342432184-12046-2-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On 7/16/2012 3:19 PM, Peter Ujfalusi wrote:
> twl6040 ES1.1 and ES1.2 have the same revid (0x01).
> ES1.3 of twl6040 REVID is 0x02.
>
> Signed-off-by: Peter Ujfalusi<peter.ujfalusi@ti.com>
> ---
>   include/linux/mfd/twl6040.h |    4 ++--
>   sound/soc/codecs/twl6040.c  |    2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
> index 6659487..e002097 100644
> --- a/include/linux/mfd/twl6040.h
> +++ b/include/linux/mfd/twl6040.h
> @@ -161,8 +161,8 @@
>   #define TWL6040_CELLS			2
>
>   #define TWL6040_REV_ES1_0		0x00
> -#define TWL6040_REV_ES1_1		0x01
> -#define TWL6040_REV_ES1_2		0x02
> +#define TWL6040_REV_ES1_1		0x01 /* Rev ES1.1 and ES1.2 */
> +#define TWL6040_REV_ES1_3		0x02
>
>   #define TWL6040_IRQ_TH			0
>   #define TWL6040_IRQ_PLUG		1
> diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
> index a36e9fc..2786de2 100644
> --- a/sound/soc/codecs/twl6040.c
> +++ b/sound/soc/codecs/twl6040.c
> @@ -653,7 +653,7 @@ int twl6040_get_hs_step_size(struct snd_soc_codec *codec)
>   {
>   	struct twl6040 *twl6040 = codec->control_data;
>
> -	if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_2)
> +	if (twl6040_get_revid(twl6040)<  TWL6040_REV_ES1_3)


Instead of doing this change why not you take a #define for revision and 
  do
if (twl6040_get_revid(twl6040)<  TWL6040_REV)

~Rajeev

>   		/* For ES under ES_1.3 HS step is 2 mV */
>   		return 2;
>   	else

