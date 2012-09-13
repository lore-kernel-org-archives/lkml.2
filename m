Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2IMKRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:17:23 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2IMKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4] media: v4l2-ctrls: add control for dpcm predictor
Date: Thu, 13 Sep 2012 02:59:22 +0200
Message-ID: <1966621.qrSMP274pk@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <504A4114.5010106@iki.fi>
References: <1346737072-24341-1-git-send-email-prabhakar.lad@ti.com> <5046DEC1.6050704@ti.com> <504A4114.5010106@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Friday 07 September 2012 21:46:44 Sakari Ailus wrote:
> 
> Could you replace the above with this text (with appropriate indentation
> etc.) while keeping the reference to Wikipedia?
> 
> ------8<------
> Differential pulse-code modulation (DPCM) compression can be used to
> compress the samples into fewer bits than they would otherwise require.
> This is done by calculating the difference between consecutive samples
> and outputting the difference which in average is much smaller than the
> values of the samples themselves since there is generally lots of
> correlation between adjacent pixels. In decompression the original
> samples are reconstructed. The process isn't lossless as the encoded
> sample size in bits is less than the original.
> 
> Formats using DPCM compression include <xref
> linkend="pixfmt-srggb10dpcm8" />.
> 
> This control is used to select the predictor used to encode the samples.

If I remember correctly this control will be used on the receiver side on 
DaVinci, to decode pixels not encode them. How is the predictor used in that 
case ? Must it match the predictor used on the encoding side ? If so I expect 
documentation to be available somewhere.

The OMAP3 ISP supports both DPCM encoding and decoding, and documents the 
predictors as

"- The simple predictor

This predictor uses only the previous same color component value as a 
prediction value. Therefore, only two-pixel memory is required.

- The advanced predictor

This predictor uses four previous pixel values, when the prediction value is 
evaluated. This means that also the other color component values are used, 
when the prediction value has been defined."

It also states the the simple predictor is preferred for 10-8-10 conversion, 
and the advanced predictor for 10-7-10 and 10-6-10 conversion.

> The main difference between the simple and the advanced predictors is
> image quality, with advanced predictor supposed to produce better
> quality images as a result. Simple predictor can be used e.g. for
> testing purposes.
> ------8<------

-- 
Regards,

Laurent Pinchart

