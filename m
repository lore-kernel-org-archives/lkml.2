Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab0GUKuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 06:50:01 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46098 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0GUKt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 06:49:59 -0400
Subject: RE: [PATCH 4/4] input: dynamically allocate ABS information
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: ext-phil.2.carmody@nokia.com
Cc: dmitry.torokhov@gmail.com, daniel@caiaq.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
In-Reply-To: <702744BC498BAE41B3AA631D95EC463058B3CFD798@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
	 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
	 <20100524160805.GO30801@buzzloop.caiaq.de>
	 <20100524161527.GC3182@core.coreip.homeip.net>
	 <20100616083903.GU17833@buzzloop.caiaq.de>
	 <20100721083048.GA21558@core.coreip.homeip.net>
	 <20100721083150.GB21558@core.coreip.homeip.net>
	 ,<20100721083216.GC21558@core.coreip.homeip.net>
	 <702744BC498BAE41B3AA631D95EC463058B3CFD798@NOK-EUMSG-01.mgdnok.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 13:42:48 +0300
Message-ID: <1279708968.2306.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jul 2010 10:49:29.0412 (UTC) FILETIME=[650A2040:01CB28C2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 11:22 +0200, ext-phil.2.carmody@nokia.com wrote:
> A tiny tiny nit...
> 
> From: Dmitry Torokhov [dmitry.torokhov@gmail.com]
> ...
> +void input_alloc_absinfo(struct input_dev *dev)
> +{
> +       if (!dev->absinfo)
> +               dev->absinfo = kcalloc(ABS_CNT, sizeof(struct input_absinfo),
> +                                       GFP_KERNEL);
> +
> +       WARN(!dev->absinfo, "%s(): kzalloc() failed?\n", __func__);
> 
> kcalloc failed, not kzalloc.

kmalloc and friends already print a warning with a stack dump when they
fail, unless this is overrided with __GFP_NOWARN, which is not the case
here. So in usually we do not print messages/warnigns when we fail to
allocate.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

