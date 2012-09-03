Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2ICJVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:21:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37183 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab2ICJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:21:16 -0400
Message-id: <50447688.4030004@samsung.com>
Date: Mon, 03 Sep 2012 11:21:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3] media: v4l2-ctrls: add control for dpcm predictor
References: <1346656851-20316-1-git-send-email-prabhakar.lad@ti.com>
In-reply-to: <1346656851-20316-1-git-send-email-prabhakar.lad@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 09:20 AM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
> determines the dpcm predictor. The predictor can be either
> simple or advanced.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: HeungJun Kim <riverful.kim@samsung.com>

Looks good.

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
> This patches has one checkpatch warning for line over
> 80 characters altough it can be avoided I have kept it
> for consistency.
> 
> Changes for v3:
> 1: Added better explanation for DPCM, pointed by Hans.
> 
> Changes for v2:
> 1: Added documentaion in controls.xml pointed by Sylwester.
> 2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
>    pointed by Sakari.
> 
>  Documentation/DocBook/media/v4l/controls.xml |   48 +++++++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-ctrls.c         |    9 +++++
>  include/linux/videodev2.h                    |    5 +++
>  3 files changed, 61 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 93b9c68..f704218 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4267,7 +4267,53 @@ interface and may change in the future.</para>
>  	    pixels / second.
>  	    </entry>
>  	  </row>
> -	  <row><entry></entry></row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_DPCM_PREDICTOR</constant></entry>
> +	    <entry>menu</entry>
> +	  </row>
> +	  <row id="v4l2-dpcm-predictor">
> +	    <entry spanname="descr"> Differential pulse-code modulation (DPCM) is a signal
> +	    encoder that uses the baseline of pulse-code modulation (PCM) but adds some
> +	    functionalities based on the prediction of the samples of the signal. The input
> +	    can be an analog signal or a digital signal.
> +
> +	    <para>If the input is a continuous-time
> +	    analog signal, it needs to be sampled first so that a discrete-time signal is
> +	    the input to the DPCM encoder.</para>

nit: this whole paragraph could fit in 2 lines.

> +
> +	    <para>Simple: take the values of two
> +	    consecutive samples; if they are analog samples, quantize them; calculate the
> +	    difference between the first one and the next; the output is the difference, and
> +	    it can be further entropy coded.</para>
> +
> +	    <para>Advanced: instead of taking a difference relative to a previous input sample,
> +	    take the difference relative to the output of a local model of the decoder process;
> +	    in this option, the difference can be quantized, which allows a good way to
> +	    incorporate a controlled loss in the encoding.</para>
> +
> +	    <para>Applying one of these two processes, short-term redundancy (positive correlation of
> +	    nearby values) of the signal is eliminated; compression ratios on the order of 2 to 4
> +	    can be achieved if differences are subsequently entropy coded, because the entropy of
> +	    the difference signal is much smaller than that of the original discrete signal treated
> +	    as independent samples.For more information about DPCM see <ulink
> +	    url="http://en.wikipedia.org/wiki/Differential_pulse-code_modulation">Wikipedia</ulink>.</para>
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +	        <row>
> +	         <entry><constant>V4L2_DPCM_PREDICTOR_SIMPLE</constant></entry>
> +	          <entry>Predictor type is simple</entry>
> +	        </row>
> +	        <row>
> +	          <entry><constant>V4L2_DPCM_PREDICTOR_ADVANCED</constant></entry>
> +	          <entry>Predictor type is advanced</entry>
> +	        </row>
> +	      </tbody>
> +	    </entrytbl>
> +	  </row>
> +	<row><entry></entry></row>
>  	</tbody>
>        </tgroup>
>        </table>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6a2ee7..2d7bc15 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -425,6 +425,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Gray",
>  		NULL,
>  	};
> +	static const char * const dpcm_predictor[] = {
> +		"Simple Predictor",
> +		"Advanced Predictor",
> +		NULL,
> +	};
>  
>  	switch (id) {
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -502,6 +507,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return mpeg4_profile;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>  		return jpeg_chroma_subsampling;
> +	case V4L2_CID_DPCM_PREDICTOR:
> +		return dpcm_predictor;
>  
>  	default:
>  		return NULL;
> @@ -732,6 +739,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
>  	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
>  	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
> +	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
>  
>  	default:
>  		return NULL;
> @@ -832,6 +840,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_ISO_SENSITIVITY_AUTO:
>  	case V4L2_CID_EXPOSURE_METERING:
>  	case V4L2_CID_SCENE_MODE:
> +	case V4L2_CID_DPCM_PREDICTOR:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_LINK_FREQ:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 6d6dfa7..ca9fb78 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2000,6 +2000,11 @@ enum v4l2_jpeg_chroma_subsampling {
>  
>  #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
>  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
> +#define V4L2_CID_DPCM_PREDICTOR			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> +enum v4l2_dpcm_predictor {
> +	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
> +	V4L2_DPCM_PREDICTOR_ADVANCED	= 1,
> +};
>  
>  /*
>   *	T U N I N G

Regards,
Sylwester
