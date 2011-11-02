Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab1KBQbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:31:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51537 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab1KBQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:31:15 -0400
Date: Wed, 2 Nov 2011 09:31:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Watts <akwatts@ymail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102163109.GA29430@core.coreip.homeip.net>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102160208.GA6657@zeus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:02:09AM -0500, Andrew Watts wrote:
> On Tue, Nov 01, 2011 at 10:46:58PM -0700, Dmitry Torokhov wrote:
> > 
> > Are you hibernating from text console or X? Can you try plugging in USB
> > keyboard and see if you are getting input? What about ssh into the box?
> 
> Forgot to answer a few of your questions. Plugging in a USB keyboard does
> not help.

OK, it looks like you do have input, what you do not have is X
functioning.

I am not sure why radeon reports lockup with that patch; serio uses
system_long_wq to schedule its long-playing works and the only other
user of system_long_wq seems to be sata, but then concurrency management
should take care of them sharing the workqueue.

Tejun, do you have any ideas here?

Thanks.

-- 
Dmitry
