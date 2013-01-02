Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3ABWb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:31:27 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55968 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3ABWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:31:24 -0500
MIME-Version: 1.0
In-Reply-To: <50E4755E.7030209@iki.fi>
References: <20121223105527.GA6230@liondog.tnic>
	<50D6E491.3030801@ukfsn.org>
	<20121223110730.GC6230@liondog.tnic>
	<50D6E8A4.1030204@ukfsn.org>
	<20121223113153.GA8918@liondog.tnic>
	<20121223115133.GA229@x4>
	<20121223122210.GA4460@liondog.tnic>
	<20121223133102.GA8153@liondog.tnic>
	<CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
	<50E3907C.4040106@iki.fi>
	<20130102120248.GC6181@x1.alien8.de>
	<CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
	<50E4755E.7030209@iki.fi>
Date: Wed, 2 Jan 2013 17:31:23 -0500
Message-ID: <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Jerome Glisse <j.glisse@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please affected people can you test if patch :
http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch

Fix the issue, you need to make sure you don't have the patch that
disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
is :
 .copy = &r600_copy_dma,
 .copy_ring_index = R600_RING_TYPE_DMA_INDEX,

Cheers,
Jerome
