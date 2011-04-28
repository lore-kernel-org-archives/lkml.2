Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab1D1WXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:23:18 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:43639 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1D1WXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:23:18 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 18:23:17 EDT
MIME-Version: 1.0
In-Reply-To: <20110428215639.GB19535@opensource.wolfsonmicro.com>
References: <1304026377-21829-1-git-send-email-michael.williamson@criticallink.com>
 <20110428215639.GB19535@opensource.wolfsonmicro.com>
From: Mike Williamson <michael.williamson@criticallink.com>
Date: Thu, 28 Apr 2011 18:17:45 -0400
Message-ID: <BANLkTikdKHi1Zr8Ae7ko7hkazR5yhHznTQ@mail.gmail.com>
Subject: Re: [PATCH] audio: tlv320aic26: fix PLL register configuration
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, tiwai@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 5:56 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 28, 2011 at 05:32:57PM -0400, Michael Williamson wrote:
>
>> -     jval = (fsref == 44100) ? 7 : 8;
>> -     dval = (fsref == 44100) ? 5264 : 1920;
>> +     jval = fsref / (aic26->mclk / 2048);
>> +     dval = fsref - jval * (aic26->mclk / 2048);
>
> I'd like some more brackets on this line, especially given the
> similarity with the previous line.  Otherwise this looks fine if a bit
> magic:

I will add some parens (and comment the magic?) and resubmit with your ack.

Thanks.

>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
