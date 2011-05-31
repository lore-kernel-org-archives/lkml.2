Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1EaShz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:37:55 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:46817
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758096Ab1EaShx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:37:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p4VIbg8T015770
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [3.0-rc1] i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	(Robert P. J. Day's message of "Tue, 31 May 2011 14:08:48 -0400
	(EDT)")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 31 May 2011 20:37:41 +0200
Message-ID: <gitycau362.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Tue, 31 May 2011 20:37:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

> On Tue, 31 May 2011, Dirk Gouders wrote:
>
>> Hello,
>>
>> I tested 3.0.0-rc1 on my notebook which has never been the best friend
>> of the i915 driver.  With linux-2.6.38-gentoo-r4 it has the problem
>> that the screen remains blank after the lid is closed and reopened, but
>> that problem I can live with.  With 3.0.0-r1 I am back to a former
>> problem that the screen goes (and remains) blank while booting.
>>
>> The next step I will do is to test linux-2.6.39-gentoo, probably I
>> did not notice information that I have to adjust boot parameters or the
>> kernel config?
>
>   based on my having lived through the i915 "black screen of death",
> pulling out my handy "git bisect" and with advice from chris wilson,
> these days, i simply apply this patch to the source:
>
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index d2c7104..a1a5d03 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -152,6 +152,8 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  	struct opregion_asle *asle = dev_priv->opregion.asle;
>  	u32 max;
>
> +return ASLE_BACKLIGHT_FAILED; // rday
> +
>  	if (!(bclp & ASLE_BCLP_VALID))
>  		return ASLE_BACKLIGHT_FAILED;
>
>
>   i tried taking it out a couple of times and immediately got the same
> i915-related problem so until i hear differently, the patch stays in.

Thanks for the hint.  I tested the patch with 3.0.0-rc1 and
unfortunately the symptoms remain the same.

Meanwhile, I tested 2.6.39-gentoo as well and it also causes that
problem.  So, this is not really a (new) 3.0.0-rc1 issue.

Best regards,

Dirk
