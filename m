Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2IDTMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:12:36 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38017 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757489Ab2IDTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:12:34 -0400
Date: Tue, 4 Sep 2012 22:12:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4] media: v4l2-ctrls: add control for dpcm predictor
Message-ID: <20120904191227.GE6834@valkosipuli.retiisi.org.uk>
References: <1346737072-24341-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346737072-24341-1-git-send-email-prabhakar.lad@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch. I've got a few comments below.

On Tue, Sep 04, 2012 at 11:07:52AM +0530, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
> determines the dpcm predictor. The predictor can be either
> simple or advanced.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> This patches has one checkpatch warning for line over
> 80 characters altough it can be avoided I have kept it
> for consistency.
> 
> Changes for v4:
> 1: Aligned the description to fit appropriately in the
> para tag, pointed by Sylwester.
> 
> Changes for v3:
> 1: Added better explanation for DPCM, pointed by Hans.
> 
> Changes for v2:
> 1: Added documentaion in controls.xml pointed by Sylwester.
> 2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
>    pointed by Sakari.
> 
>  Documentation/DocBook/media/v4l/controls.xml |   46 +++++++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-ctrls.c         |    9 +++++
>  include/linux/videodev2.h                    |    5 +++
>  3 files changed, 59 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 93b9c68..ad873ea 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4267,7 +4267,51 @@ interface and may change in the future.</para>
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
> +	    <para>If the input is a continuous-time analog signal, it needs to be sampled
> +	    first so that a discrete-time signal is the input to the DPCM encoder.</para>
> +
> +	    <para>Simple: take the values of two consecutive samples; if they are analog
> +	    samples, quantize them; calculate the difference between the first one and the
> +	    next; the output is the difference, and it can be further entropy coded.</para>
> +
> +	    <para>Advanced: instead of taking a difference relative to a previous input sample,
> +	    take the difference relative to the output of a local model of the decoder process;
> +	    in this option, the difference can be quantized, which allows a good way to
> +	    incorporate a controlled loss in the encoding.</para>

This is directly from Wikipedia, isn't it?

What comes to the content, DPCM in the context of V4L2 media bus codes, as a
digital interface, is always digital. So there's no need to document it.
Entropy coding is also out of the question: the samples of the currently
defined formats are equal in size.

Another thing what I'm not sure is the definition of the simple and advanced
encoders. I've seen sensors that allow you to choose which one to use, but
the documentation hasn't stated what the actual implementation is. Does TI
documentation do so?

In V4L2 documentation we should state what is common in the hardware
documentation, and that is mostly limited to "simple" and "advanced". I
really don't know enough that I could say what the exact implamentation of
those two are in all of the cases.

I suggest we leave just a few words of the DPCM compression itself (roughly
the factual content of the first paragraph with the exception of the
reference to analogue signal) and a link to Wikipedia.

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

As the control's name is already "DPCM Predictor", I think you can drop
" Predictor" from the menu items.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
