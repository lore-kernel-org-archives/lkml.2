Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1HKKB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:01:59 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60638 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754817Ab1HKKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:01:58 -0400
Message-ID: <4E43A808.4050105@metafoo.de>
Date: Thu, 11 Aug 2011 11:59:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mike Frysinger <vapier.adi@gmail.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/4] ASoC: DAPM: Allow multiple mixer sources
 to be routed via the same switch
References: <1312948364-2587-1-git-send-email-lars@metafoo.de> <20110811093140.GB18454@opensource.wolfsonmicro.com>
In-Reply-To: <20110811093140.GB18454@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 11:31 AM, Mark Brown wrote:
> On Wed, Aug 10, 2011 at 05:52:41AM +0200, Lars-Peter Clausen wrote:
>> Currently it is only possible to route one source per switch into a mixer.
>> This patch modifies the code, so that it is possible to route multiple sources
>> into a mixer via the same switch. One use-case for this is routing a stereo
>> channel pair into a mono-mixer via the same switch.
>
> I'd have thought the dapm_is_shared_control() stuff should handle this?


The dapm_is_shared_control() stuff is about sharing kcontrols between multiple
muxes. This is about sharing the same kcontrol between multiple paths of the
same mixer.

i.e

{ "Mono Mixer", "DAC", "Left DAC" },
{ "Mono Mixer", "DAC", "Right DAC" },

doesn't work without this patch.
