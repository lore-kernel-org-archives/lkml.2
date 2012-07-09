Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2GIFZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:25:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9018 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2GIFZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:25:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 08 Jul 2012 22:22:03 -0700
Message-ID: <4FFA6BCA.2040101@nvidia.com>
Date: Mon, 9 Jul 2012 14:27:38 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm_backlight: pass correct brightness to callback
References: <1341807700-7103-1-git-send-email-acourbot@nvidia.com> <20120709051001.GA10108@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120709051001.GA10108@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 02:10 PM, Thierry Reding wrote:
> I had to actually read this patch a number of times and then realized I
> was completely missing the context. Looking at the whole function makes
> it more obvious what you mean.
>
> However I think it'd be much clearer if we just passed the value of
> bl->props.brightness into the callbacks, that way we can avoid the
> additional variable.

This won't work I'm afraid, as brightness can be modified prior to being 
passed to the callback function:

	if (bl->props.power != FB_BLANK_UNBLANK)
		brightness = 0;

	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
		brightness = 0;

	if (pb->notify)
		brightness = pb->notify(pb->dev, brightness);

Alex.
