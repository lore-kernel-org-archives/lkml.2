Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1K3CfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:35:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:37395 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab1K3CfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:35:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,595,1315206000"; 
   d="scan'208";a="80464553"
Date: Wed, 30 Nov 2011 10:34:18 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <feng.tang@intel.com>, "Clark, Joel" <joel.clark@intel.com>
Subject: Re: [PATCH 2/2] Input: tsc2007 - Add a z1_low_threshhold platform
 data parameter
Message-ID: <20111130103418.4514b630@feng-i7>
In-Reply-To: <20111129092310.GB21758@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
	<1322554378-348-2-git-send-email-feng.tang@intel.com>
	<20111129092310.GB21758@core.coreip.homeip.net>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 17:23:10 +0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Tue, Nov 29, 2011 at 04:12:58PM +0800, Feng Tang wrote:
> > This originates from a patch in Meego IVI kernel with the name
> > 	linux-2.6.37-connext-0027-tsc2007.patch
> > There is no author info excepte a line "From  MeeGo
> > <kernel@meego.com>"
> > 
> > When integrating tsc2007 on Intel IVI platform, there are a lot of
> > noise data whose z1 value is around 10 which is not a sane "z1". So
> > add a "z1_low_threshhold" to filter those nosie data, to make the
> > device work properly.
> 
> Sounds like a task for userspace to ignore pressure that is too low.
> Bonus points for making it configurable so user can adjust
> sensitivity.

Actually, there is one more point :), without this patch, the driver won't
work on our platforms.

The tsc2007_soft_irq will keep reading the input data unless there is no
valid pressure data. In our case, those noise data will be seen as valid
data during tsc2007_calculate_pressure(), and the tsc2007_soft_irq will
run endlessly.

Thanks,
Feng 

> 
> Thanks.
> 
