Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1CKSFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:05:25 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:59588 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab1CKSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:05:23 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Hy18s5fOziHSNdG6QUZE85bg0Bb9cAqE42mVQ@mail.gmail.com>
References: <1299864633-27542-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTi=Hy18s5fOziHSNdG6QUZE85bg0Bb9cAqE42mVQ@mail.gmail.com>
Date: Fri, 11 Mar 2011 12:05:23 -0600
Message-ID: <AANLkTin_2yo705Ka3KO_09nK3ZUEi_0uYfi6fKQqwBVV@mail.gmail.com>
Subject: Re: [RESEND PATCH] staging: tidspbridge: protect dmm_map properly
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Mar 11, 2011 at 11:38 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Fri, Mar 11, 2011 at 7:30 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> We need to protect not only the dmm_map list, but the individual
>> map_obj's, otherwise, we might be building the scatter-gather list with
>> garbage. So, use the existing proc_lock for that.
>>
>> I observed race conditions which caused kernel panics while running
>> stress tests, also, Tuomas Kulve found it happening quite often in
>> Gumstix Over. This patch fixes those.
>>
>> Cc: Tuomas Kulve <tuomas@kulve.fi>
>> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
>
> Omar, 2.6.38 is imminent, if this patch has any chance of getting in,
> I think you would need to push it soon.

I'll push it to my queue, however I don't think this would be even
considered to make it before the official 2.6.38 which should happen
in the next few days, given that it should climb to staging tree first
and from there to mainline... we could attempt to shot directly to the
mainline kernel, but that would raise a few eyebrows and in the end be
rejected as well because this is a staging driver which is still in
process of cleanup.

OTOH, this patch was there long ago, since December, but I just lost
the track of it at the moment, along with the other proposed
solutions, so I take it as my fault for not picking it up then.

Regards,

Omar
