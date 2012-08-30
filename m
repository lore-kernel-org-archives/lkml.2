Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab2H3O7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:59:55 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2092 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2H3O7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:59:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v2] media: v4l2-ctrls: add control for dpcm predictor
Date: Thu, 30 Aug 2012 07:57:44 -0700
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-lyonesse; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1346313496-3652-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1346313496-3652-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208300757.44775.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar!

I've got some documentation review comments below...

On Thu August 30 2012 00:58:16 Prabhakar Lad wrote:
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
> ---
> This patches has one checkpatch warning for line over
> 80 characters altough it can be avoided I have kept it
> for consistency.
> 
> Changes for v2: 
> 1: Added documentaion in controls.xml pointed by Sylwester.
> 2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
>    pointed by Sakari.
> 
>  Documentation/DocBook/media/v4l/controls.xml |   25 ++++++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-ctrls.c         |    9 +++++++++
>  include/linux/videodev2.h                    |    5 +++++
>  3 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 93b9c68..84746d0 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4267,7 +4267,30 @@ interface and may change in the future.</para>
>  	    pixels / second.
>  	    </entry>
>  	  </row>
> -	  <row><entry></entry></row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_DPCM_PREDICTOR</constant></entry>
> +	    <entry>menu</entry>
> +	  </row>
> +	  <row id="v4l2-dpcm-predictor">
> +	    <entry spanname="descr"> DPCM Predictor: depicts what type of prediction
> +	    is used simple or advanced.

This is not useful information. It basically just rephrases the name of the
define without actually telling me anything.

I would expect to see here at least the following:

- what the DPCM abbreviation stands for
- a link or bibliography reference to the relevant standard (if there is any)
- a high-level explanation of what this do and what the difference is between
 simple and advanced.

If this is part of a video compression standard, then this control would probably
belong to the MPEG control class as well.

Regards,

    Hans


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
> 
