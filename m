Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1BQX0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:26:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5699 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BQX0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:26:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Feb 2011 15:19:41 -0800
From: Andrew Chew <AChew@nvidia.com>
To: "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Thu, 17 Feb 2011 15:26:17 -0800
Subject: RE: [PATCH v4 1/1] [media] ov9740: Initial submit of OV9740 driver.
Thread-Topic: [PATCH v4 1/1] [media] ov9740: Initial submit of OV9740 driver.
Thread-Index: AcvO+dGy16jWrGlDRwO4hWHLgAR7ZQAABMcA
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BD96CFC2@HQMAIL03.nvidia.com>
References: <1297980873-18022-1-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1102180022080.1841@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102180022080.1841@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks good now, thanks, I'll queue it for 2.6.39. Just 
> one question:
> 
> On Thu, 17 Feb 2011, achew@nvidia.com wrote:
> 
> > From: Andrew Chew <achew@nvidia.com>
> > 
> > This soc_camera driver is for Omnivision's OV9740 sensor.  
> This initial
> > submission provides support for YUV422 output at 1280x720 
> (720p), which is
> > the sensor's native resolution.  640x480 (VGA) is also 
> supported, with
> > cropping and scaling performed by the sensor's ISP.
> 
> Didn't you mean to say just "scaling?" You're not 
> implementing cropping. 
> You could, certainly, fake scaling with cropping, but are you 
> really using 
> both to switch between 720p and VGA? No need for a v5, just 
> tell me how to 
> change the comment.

There really is cropping.  The native resolution of the OV9740 sensor is a different aspect ratio than VGA.  To preserve the square pixels, first we crop both the left and right sides, and then scale down.