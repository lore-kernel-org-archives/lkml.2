Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1BOAIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:08:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5164 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1BOAIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:08:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 14 Feb 2011 15:56:18 -0800
From: Andrew Chew <AChew@nvidia.com>
To: "'Erik Gilling'" <konkers@android.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Date: Mon, 14 Feb 2011 16:08:36 -0800
Subject: RE: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Topic: [PATCH 1/1] [tegra] Make syncpt routines accessible by drivers
Thread-Index: AcvMoIrguTwj97fwQX+uX3HMnfjBjQAA0jag
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BD96CFB1@HQMAIL03.nvidia.com>
References: <1297726034-32762-1-git-send-email-achew@nvidia.com>
 <AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
In-Reply-To: <AANLkTinvpo=R1pjvykEZVXV08D+uXLJa=R8CDcMFWWpT@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want to use syncpts you should be an nvhost_driver link the dc.

Looking at drivers/video/tegra/dc, I notice that it gets access to the syncpt functions by using a relative path (../host/dev.h) to include dev.h, which in turn includes nvhost_syncpt.h (in drivers/video/tegra/host).  Is this proper form?

This syncpt access is for a Tegra V4L2 driver, which will live in drivers/media/video.  I was trying to avoid using relative paths for #includes.  I assumed that the header files in drivers/video/tegra/host were not meant to be publicly available to other drivers, which is why I looked for some precedent in how nvhost functions were made available to other kernel drivers, hence I modeled this after nvmap.