Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0LCMUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:20:03 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:36335 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab0LCMUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:20:02 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix inconsistent meaning of default case while checking alc5623->id
Organization: RtpNet
References: <1291368357.20452.6.camel@mola>
Date: Fri, 03 Dec 2010 13:21:22 +0100
In-Reply-To: <1291368357.20452.6.camel@mola> (Axel Lin's message of "Fri, 03
	Dec 2010 17:25:57 +0800")
Message-ID: <874oavqc71.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

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

oh, yeah. makes sense. Thanks for noticing.


Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
