Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab1D1Oh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:37:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39307 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab1D1Ohy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:37:54 -0400
Date: Thu, 28 Apr 2011 15:37:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
Message-ID: <20110428143724.GQ17290@n2100.arm.linux.org.uk>
References: <1303963358-4652-1-git-send-email-haojian.zhuang@gmail.com> <20110428102212.2d8d607c@endymion.delvare> <BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com> <20110428161625.5eaacb85@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428161625.5eaacb85@endymion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 04:16:25PM +0200, Jean Delvare wrote:
> Are you suggesting that the hardware lock wouldn't mind being taken
> twice by the AP side? If it is the case, then indeed the software mutex
> is still needed to prevent it from happening.
> 
> That being said... I guess that avoiding a priority inversion is a good
> enough reason to always take the rt_mutex, regardless of the hardware
> lock implementation.
> 
> So, this patch is
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> I guess it makes more sense for me to let Ben apply it, as the other
> two patches in the series are for him too. This will avoid a dependency
> between our trees.

Only change I'd suggest is passing adapter to the hardware_lock/unlock
methods.  Having no arguments what so ever in generic code for this kind
of stuff looks rather strange and limiting.
