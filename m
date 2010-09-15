Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0IOSH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:07:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab0IOSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:07:58 -0400
Message-ID: <4C910B70.8060305@vlnb.net>
Date: Wed, 15 Sep 2010 22:07:44 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
References: <4C8F886E.2080407@vlnb.net> <20100915055649.GB22219@core.coreip.homeip.net> <4C90DDB1.9020003@vlnb.net>
In-Reply-To: <4C90DDB1.9020003@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:UZW3hHNefEcP5FWln1cU65SBUs2WHRiqtuH6+BvgHFN
 JzOhiY4sbCKzcmmTBs7lFY/KeJZZ0z2fAofuxJ6+ernE+Fhwh9
 4dwd/LlvN/H+rA131K8AD898z/Q8aQtgnNoO/0HA+cRUtnM0qk
 0rUrg7t7AMlSdeHNBvWSlAEwehaZzzDj9NunpWFc+87SvwjKE+
 FHz/1xokZwDd17GNixvbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin, on 09/15/2010 06:52 PM wrote:
> It, definitely,
> isn't a piece of beauty, but it's simple and works, so, I believe, good enough. User space,
> anyway, is supposes to hide all the complexities of the direct SYSFS manipulations under
> higher level management tools like scstadmin.

There's one more point I forgot to note why having the separate SYSFS
management thread is good: it naturally serializes all SYSFS management
operations, so allows to simplify locking in target drivers and dev
handlers. For instance, it allows in add_target() callback don't bother
if del_target() or another add_target() for the same target name called
simultaneously.

Thanks,
Vlad
