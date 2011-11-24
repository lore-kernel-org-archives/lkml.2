Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1KXT5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:57:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41901 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1KXT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:57:09 -0500
Date: Thu, 24 Nov 2011 11:57:03 -0800
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
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system
 suspend
Message-ID: <20111124195703.GA6735@google.com>
References: <1322137287.2597.10.camel@hp6530s>
 <Pine.LNX.4.44L0.1111241123030.21532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111241123030.21532-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 24, 2011 at 11:36:20AM -0500, Alan Stern wrote:
> I think this email discussion has answered his objection: The only SCSI
> top-level driver implementing runtime suspend is sd, and sd treats
> runtime suspend the same as system sleep.  It might be a good idea to
> add a comment with this explanation along with the new code, however.

Hmmm... I see.  This shouldn't affect host controller states - we'll
be skipping only the drive PM transitions, right?  As long as it's
well documented, I guess it's okay but at the same time I don't think
it's such a big deal to spin up drives when the system is entering
hibernation from runtime powersave.  On most systems, they'll need to
be spun up for image dump pretty soon anyway.

Thanks.

-- 
tejun
