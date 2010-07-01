Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0GAJzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:55:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25723 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0GAJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:55:08 -0400
Subject: Re: [PATCH] OMAP:DSS2:OMAPFB: Fix probe error path
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Afzal Mohammed <lazfamam@gmail.com>
Cc: "Syrjala Ville (Nokia-D/Helsinki)" <ville.syrjala@nokia.com>,
       "tj@kernel.org" <tj@kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1277907327-3443-1-git-send-email-lazfamam@gmail.com>
References: <1277907327-3443-1-git-send-email-lazfamam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 12:54:32 +0300
Message-ID: <1277978072.2474.283.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2010 09:54:39.0681 (UTC) FILETIME=[6BF20310:01CB1903]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-06-30 at 16:15 +0200, ext Afzal Mohammed wrote:
> If enabling fb0 fails in omapfb_create_framebuffers(), remove
> sysfs file before returning to probe. This is required to complete
> the cleanup in the above mentioned error case.

omapfb frees the resources in omapfb_free_resources(). I believe
removing sysfs should also be put into omapfb_free_resources() to be
consistent, and not as an explicit call like in this patch.

However, I'm not sure if some sysfs-allocated flag is needed for this to
work in all cases.

 Tomi


