Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab1HVUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:55:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1HVUzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:55:55 -0400
Message-ID: <4E52C252.9060904@canonical.com>
Date: Mon, 22 Aug 2011 13:55:46 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 4/9 v5] Input: synaptics - add image sensor support
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org> <1314011163-19098-5-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1314011163-19098-5-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 04:05 AM, Daniel Kurtz wrote:
> Synaptics makes (at least) two kinds of touchpad sensors:
>  * Older pads use a profile sensor that could only infer the location
>    of individual fingers based on the projection of their profiles
>    onto row and column sensors.
>  * Newer pads use an image sensor that can track true finger position
>    using a two-dimensional sensor grid.
> 
> Both sensor types support an "Advanced Gesture Mode":
>  When multiple fingers are detected, the touchpad sends alternating
>  "Advanced Gesture Mode" (AGM) and "Simple Gesture Mode" (SGM)
>  packets.
>  The AGM packets have w=2, and contain reduced resolution finger data
>  The SGM packets have w={0,1} and contain full resolution finger data
> 
> Profile sensors try to report the "upper" (larger y value) finger in
> the SGM packet, and the lower (smaller y value) in the AGM packet.
> However, due to the nature of the profile sensor, they easily get
> confused when fingers cross, and can start reporting the x-coordinate
> of one with the y-coordinate of the other.  Thus, for profile
> sensors, "semi-mt" was created, which reports a "bounding box"
> created by pairing min and max coordinates of the two pairs of
> reported fingers.
> 
> Image sensors can report the actual coordinates of two of the fingers
> present.  This patch detects if the touchpad is an image sensor and
> reports finger data using the MT-B protocol.
> 
> NOTE: This patch only adds partial support for 2-finger gestures.
>       The proper interpretation of the slot contents when more than
>       two fingers are present is left to later patches.  Also,
>       handling of 'number of fingers' transitions is incomplete.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

It's fine with me. It adds a bit of asymmetry in packet processing
between mt and non-mt trackpads. This could be reworked by splitting
synaptics_process_packet() up into an mt case function (which is what
synaptics_image_sensor_process() is), and a non-mt case function. I
think that would be nice, but not a big deal so:

Acked-by: Chase Douglas <chase.douglas@canonical.com>
