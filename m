Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1DMMcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:32:13 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43834 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1DMMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:32:12 -0400
Message-ID: <4DA597E3.807@metafoo.de>
Date: Wed, 13 Apr 2011 14:32:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ASoC: Call snd_soc_new_widgets() after registering
 cards DAPM widgets
References: <1302629465-21315-1-git-send-email-lars@metafoo.de> <1302629465-21315-2-git-send-email-lars@metafoo.de> <20110413003847.GC24267@opensource.wolfsonmicro.com>
In-Reply-To: <20110413003847.GC24267@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 02:38 AM, Mark Brown wrote:
> On Tue, Apr 12, 2011 at 07:31:02PM +0200, Lars-Peter Clausen wrote:
>> After registering new DAPM widgets nd_soc_new_widgets() must be called,
>> otherwise DAPM for those new widgets will not work.
>>
>> snd_soc_new_widgets() is placed after the card late_probe call, so cards
>> can register new DAPM widgets in there.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>
> There's already a call for this in post_component_init(), it just needs
> to be moved later in the sequence now.

post_component_init() is called for each registered codec (and auxdev).
Since all the DAPM widgets are kept in one list now it probably makes sense to
traverse that list only once, when all components have been registered.
But snd_soc_dapm_new_widgets also calls dapm_power_widgets which operates on
the passed dapm_context, will it be without any effect on the DAPM context,
when it is called on a newly allocated context?

Otherwise I would say call snd_soc_dapm_new_widgets once for the cards
dapm_context and snd_soc_dapm_sync for each codec context.

- Lars
