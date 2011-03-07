Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1CGT3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:29:06 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:42597 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab1CGT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:29:04 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
Date: Mon, 7 Mar 2011 13:29:02 -0600
Message-ID: <AANLkTimsrmGdBEEpV7OPFtGG=yRfeVBPxGP5y8gkUHfJ@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Mon, Mar 7, 2011 at 12:02 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Dec 20, 2010 at 7:12 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> We need to protect not only the dmm_map list, but the individual
>> map_obj's, otherwise, we might be building the scatter-gather list with
>> garbage. So, use the existing proc_lock for that.
>>
>> I observed race conditions which caused kernel panics while running
>> stress tests. This patch fixes those.
>
> I just heard that Tuomas Kulve is getting a lot of panics on Gumstix
> Overo. I propose we apply this patch on the stable tree ASAP, and if
> there's no better proposals, also on .38.

Can you or Tuomas share the bug report data (panic log, test case
maybe)? I would like to discard issues affected by timing that could
be hidden with this patch.

I agree that for the time being this needs to be sent upstream, even
if in paper Ohad's patch solves the issue without side effects of
locking.

Thanks,

Omar
