Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2JAJQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:16:19 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49530 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752429Ab2JAJQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:16:16 -0400
Date: Mon, 1 Oct 2012 12:16:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LDOC <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4] media: v4l2-ctrls: add control for test pattern
Message-ID: <20121001091548.GB14107@valkosipuli.retiisi.org.uk>
References: <1348553345-14296-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1348553345-14296-1-git-send-email-prabhakar.lad@ti.com>
X-Identity-Key: id13
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120909
 Firefox/15.0.1 SeaMonkey/2.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>
> add V4L2_CID_TEST_PATTERN of type menu, which determines
> the internal test pattern selected by the device.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Landley <rob@landley.net>
> ---
>   This patches has one checkpatch warning for line over
>   80 characters altough it can be avoided I have kept it
>   for consistency.
>
>   Changes for v4:
>   1: Fixed some grammar/style issues, pointed by Hans.
>
>   Changes for v3:
>   1: Removed the menu for test pattern, pointed by Sakari.
>
>   Changes for v2:
>   1: Included display devices in the description for test pattern
>     as pointed by Hans.
>   2: In the menu replaced 'Test Pattern Disabled' by 'Disabled' as
>     pointed by Sylwester.
>   3: Removed the test patterns from menu as the are hardware specific
>     as pointed by Sakari.
>
>   Documentation/DocBook/media/v4l/controls.xml |   10 ++++++++++
>   drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
>   include/linux/videodev2.h                    |    1 +
>   3 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index f0fb08d..5450d31 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4313,6 +4313,16 @@ interface and may change in the future.</para>
>   	      </tbody>
>   	    </entrytbl>
>   	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry>
> +	    <entry>menu</entry>
> +	  </row>
> +	  <row id="v4l2-test-pattern">
> +	    <entry spanname="descr"> Some capture/display/sensor devices have
> +	    the capability to generate test pattern images. These hardware
> +	    specific test patterns can be used to test if a device is working
> +	    properly.</entry>
> +	  </row>
>   	<row><entry></entry></row>
>   	</tbody>
>         </tgroup>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 8f2f40b..41b7732 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -740,6 +740,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
>   	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
>   	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
> +	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
>
>   	default:
>   		return NULL;
> @@ -841,6 +842,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_EXPOSURE_METERING:
>   	case V4L2_CID_SCENE_MODE:
>   	case V4L2_CID_DPCM_PREDICTOR:
> +	case V4L2_CID_TEST_PATTERN:
>   		*type = V4L2_CTRL_TYPE_MENU;
>   		break;
>   	case V4L2_CID_LINK_FREQ:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index ca9fb78..7014c0b 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2005,6 +2005,7 @@ enum v4l2_dpcm_predictor {
>   	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
>   	V4L2_DPCM_PREDICTOR_ADVANCED	= 1,
>   };
> +#define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
>
>   /*
>    *	T U N I N G
>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

I'd suggest to rebase this under the DPCM predictor patch. As the choice of
the predictor affects the resulting format, it has to be the same on the
transmitter and the receiver, and also affects the in-memory pixel format.

I'll prepare an RFC on the topic shortly.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
