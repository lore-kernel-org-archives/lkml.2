Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0JLPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:47:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:54382 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab0JLPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:47:06 -0400
Message-ID: <4CB482EC.7050800@windriver.com>
Date: Tue, 12 Oct 2010 10:46:52 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drm,kdb,kms: Add an enter argument to mode_set_base_atomic()
 API
References: <1286887801-8179-1-git-send-email-jason.wessel@windriver.com><1286887801-8179-4-git-send-email-jason.wessel@windriver.com> <20101012083827.12b8ccce@jbarnes-desktop>
In-Reply-To: <20101012083827.12b8ccce@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2010 15:46:53.0407 (UTC) FILETIME=[B12CEEF0:01CB6A24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 10:38 AM, Jesse Barnes wrote:
> On Tue, 12 Oct 2010 07:49:59 -0500
> Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> Some devices such as the pre nv02 chips have enter and exit
>> constraints where hardware compression must be turned off and
>> re-enabled on resuming normal operations.
>>
>> This patch extends the mode_set_base_atomic() call to pass an argument
>> to indicate if this is an entry or an exit from an atomic kernel mode
>> set change.  Individual drm drivers can properly save and restore
>> state accordingly.
>>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
>> CC: David Airlie <airlied@linux.ie>
>> CC: dri-devel@lists.freedesktop.org
>> ---
>>  drivers/gpu/drm/drm_fb_helper.c             |    5 +++--
>>  drivers/gpu/drm/i915/intel_display.c        |    4 ++--
>>  drivers/gpu/drm/nouveau/nv04_crtc.c         |    2 +-
>>  drivers/gpu/drm/nouveau/nv50_crtc.c         |    2 +-
>>  drivers/gpu/drm/radeon/atombios_crtc.c      |    2 +-
>>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
>>  drivers/gpu/drm/radeon/radeon_mode.h        |    4 ++--
>>  include/drm/drm_crtc_helper.h               |    3 ++-
>>  8 files changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
>> index 6a5e403..625a2d5 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -263,7 +263,8 @@ int drm_fb_helper_debug_enter(struct fb_info *info)
>>  			funcs->mode_set_base_atomic(mode_set->crtc,
>>  						    mode_set->fb,
>>  						    mode_set->x,
>> -						    mode_set->y);
>> +						    mode_set->y,
>> +						    1);
>>     
>
> An enum for the last arg would make this call much less mysterious. :)
>
>   
Is there anything that is already predefined or would you prefer just
true or false?

This could be changed to a bool because there are really only two
states, entering and exiting.  If you provide some guidance on the
preferred naming, I can re-spin the patch.

Thanks,
Jason.
