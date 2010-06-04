Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0FDG7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:59:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39726 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0FDG7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fK0BL6OYdyu1NEF6gWrRf7pNT9MWibBfXTCP+iKwDBZpi6FbJQAexVY8REJB82q/O/
         j6AHa6WxbQwjg0DRMcrstfXDQ+2SzjEKdCqjN3AatoQO9LZmiP1CEIZ5ySVzjKBW4G+I
         /CEzGhoxNmmxwGjkOnF8KHr3StivjWYFcHJ8g=
Date: Thu, 3 Jun 2010 23:59:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 0/4] input: evdev: Dynamic buffers (rev3)
Message-ID: <20100604065915.GF21239@core.coreip.homeip.net>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Jun 03, 2010 at 10:00:58AM +0200, Henrik Rydberg wrote:
> Dmitry,
> 
> Please find enclosed the third version of the evdev buffer patches.
> 
> This version has one more patch; the locking mechanism has been broken
> out into its own file, buflock.h, adding a fair amount of
> documentation. The mechanism has been moderately tested, showing
> graceful dropping of packets as the buffer size gets smaller and the
> number of simultaneous readers gets larger.
> 
> In the second patch, the per-client buffer is replaced by the buflock
> reader, and the spinlock name is changed to reflect the reduced area
> it covers. The third patch only has trivial changes, and the fourth
> patch is unchanged, but included for completeness.
> 

I think the patchet moves things in the right direction, however I am
unsure at the moment about buflock implementation. Any chance you coudl
redo the series without the buflock (with readers taking dev->event_lock
for now) and once buflock is sorted we can switch to is as a followup).

Thanks.

-- 
Dmitry
