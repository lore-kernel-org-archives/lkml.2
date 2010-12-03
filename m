Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0LCMBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:01:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab0LCMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:01:30 -0500
Subject: Re: [PATCH] ASoC: Fix inconsistent meaning of default case while
 checking alc5623->id
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291368357.20452.6.camel@mola>
References: <1291368357.20452.6.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 12:01:26 +0000
Message-ID: <1291377686.3271.42.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 17:25 +0800, Axel Lin wrote:
> In alc5623_i2c_probe(),
> the default case for checking alc5623->id behaves the same as case 0x23.
> However, In alc5623_probe() the default case for checking alc5623->id
> becomes to be the same as case 0x21.
> This makes the meaning of default case inconsistent.
> 
> Since we have checked codec id in alc5623_i2c_probe() by comparing
> vid2 with id->driver_data, it is not possible to run into the default case now.
> 
> In case we may add more supported devices to alc5623_i2c_table in the future,
> this patch changes the default case return -EINVAL to let people know that
> they should not run into this case. They should also add a new case accordingly
> for the new id.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

