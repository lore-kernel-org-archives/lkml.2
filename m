Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2KIPpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:45:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54113 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2KIPpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:45:21 -0500
MIME-Version: 1.0
In-Reply-To: <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
	<1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
Date: Fri, 9 Nov 2012 16:45:19 +0100
Message-ID: <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/9 Thierry Reding <thierry.reding@avionic-design.de>:
> +/* all fields little endian */
> +struct hdmi_audio_infoframe {
> +       /* PB0 */
> +       u8 csum;
> +
> +       /* PB1 */
> +       unsigned cc:3; /* channel count */
> +       unsigned res1:1;
> +       unsigned ct:4; /* coding type */
> +
> +       /* PB2 */
> +       unsigned ss:2; /* sample size */
> +       unsigned sf:3; /* sample frequency */
> +       unsigned res2:3;
> +
> +       /* PB3 */
> +       unsigned cxt:5; /* coding extention type */
> +       unsigned res3:3;
> +
> +       /* PB4 */
> +       u8 ca; /* channel/speaker allocation */
> +
> +       /* PB5 */
> +       unsigned res5:3;
> +       unsigned lsv:4; /* level shift value */
> +       unsigned dm_inh:1; /* downmix inhibit */
> +
> +       /* PB6-10 reserved */
> +       u8 res6;
> +       u8 res7;
> +       u8 res8;
> +       u8 res9;
> +       u8 res10;
> +} __packed;

I was told it won't work on different endian devices. See
[RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html

-- 
Rafał
