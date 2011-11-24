Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1KXXBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:01:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50095 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1KXXBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111241735300.26861-100000@netrider.rowland.org>
References: <20111124195703.GA6735@google.com>
	<Pine.LNX.4.44L0.1111241735300.26861-100000@netrider.rowland.org>
Date: Thu, 24 Nov 2011 15:01:10 -0800
X-Google-Sender-Auth: xA0uwMygfO1Dw4ZJgBX3t1wb2kA
Message-ID: <CAOS58YMCv0syM7ggzaJeQp6oQxdNAJ9Y5Yn+6Q_Tb7ZjcvPzng@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 24, 2011 at 2:54 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Therefore, when entering the SUSPEND or HIBERNATE stages of system
> sleep, we can skip the callback to the driver if the device is already
> in runtime suspend.  When entering the FREEZE stage, however, we should
> first issue a runtime resume.  The overhead of doing this is
> negligible, because a suspended drive would be spun up during the THAW
> stage of hibernation anyway.

My brain is half fried at the moment so maybe you're saying the same
thing, but I hope this is something simple. Like...

    /* for libata runtime suspend is equivalent to suspend */
    if (runtime suspended && target == SUSPEND) {
        yeah! skip drive pm ops;
    } else {
        end runtime pm;
        ask EH to enter target PM state;
    }

I really don't think we need to optimize this further than this.

Thanks.

-- 
tejun
