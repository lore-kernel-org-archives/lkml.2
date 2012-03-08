Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2CHPqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:46:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39264 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab2CHPqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:46:40 -0500
MIME-Version: 1.0
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8918@MEP-EXCH.meprolight.com>
References: <CAOMZO5DnP7+zupy9vwBPS0+2XtKM1+nLbwCqBzuCqEG5OWbZRQ@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
	<CAOMZO5Amo0XFf+TV7PprCL079C5Y0qKmo+k-FfShU7k4SG7W6Q@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8913@MEP-EXCH.meprolight.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8918@MEP-EXCH.meprolight.com>
Date: Thu, 8 Mar 2012 12:46:38 -0300
Message-ID: <CAOMZO5A6T+WdOE41Wx6Nctwz9wk8FKaxzjbAt_woZkCnuodNYg@mail.gmail.com>
Subject: Re: I.MX35 PDK
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/12, Alex Gershgorin <alexg@meprolight.com> wrote:

> Setting pipeline to PAUSED ...mx3-camera mx3-camera.0: MX3 Camera driver
> attached to camera 0
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0.GstPad:src: caps =
> video/x-raw-yuv, format=(fourcc)UYVY, framerate=(fraction)25/1,
> width=(int)320, height=(int)240, interlaced=(boolean)false
> Pipeline is live and does not need PREROLL ...
> WARNING: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not
> get parameters on device '/dev/video0'
> Additional debug info:
> v4l2src_calls.c(240): gst_v4l2src_set_capture ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> system error: Invalid argument

Looks like some kind of Gstreamer issue.

You could also try:
gst-launch -v v4l2src ! fbdevsink

or gst-launch -v v4l2src ! filesink location= raw.data

If you still get Gstreamer issues you can try v4l2grab utility:
http://git.linuxtv.org/v4l-utils.git/blob/de42be924c5154732bc8dfd1c8bc7812985ab2d6?f=contrib/test/v4l2grab.c

Good luck!
