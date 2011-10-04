Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1JDJYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:24:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40357 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1JDJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:24:43 -0400
Subject: ASoC: snd_soc_codec_set_cache_io does not set codec->hw_write 
 callback now
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 17:24:32 +0800
Message-ID: <1317720272.2536.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I just found that after commit be3ea3b9e
"SoC: Use new register map API for ASoC generic physical I/O",
snd_soc_codec_set_cache_io does not set codec->hw_write any more.

It is still used in some drivers. e.g.
In wm8988_resume, we call codec->hw_write(codec->control_data, data, 2);

For the drivers that is using snd_soc_codec_set_cache_io now,
where is the place to set codec->hw_write callback now? 

Regards,
Axel

