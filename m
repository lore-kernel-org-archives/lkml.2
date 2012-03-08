Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2CHCmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:42:12 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33884 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132Ab2CHCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:42:08 -0500
Date: Wed, 7 Mar 2012 18:42:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 05/11] android: ram_console: split out persistent ram
Message-ID: <20120308024203.GA25842@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
 <1331170478-30538-6-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331170478-30538-6-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 05:34:32PM -0800, John Stultz wrote:
> From: Colin Cross <ccross@android.com>
> 
> Split ram_console into two halves.
> 
> persistent_ram is a set of apis that handle a block of memory
> that does not get erased across a reboot.  It provides functions
> to fill it as a single buffer or a ring buffer, and to extract
> the old data after a reboot.  It handles ecc on the data to
> correct bit errors introduced during reboot.

That's a nice idea, but why are you rolling your own interface here and
not using the built-in one that the kernel already provides?  Is there
something lacking with what we have today that requires you to create
something different?  If so, why not just modify the existing interface
to make it work for you, that way the tools already created will work
automatically, and you will not have problems later ripping this out and
porting it to the in-kernel api.

Because of this, sorry, I can't take the rest of these patches in this
series.  If the 10th or 11th ones are needed, care to refresh it against
my tree and resend it so that I can take it?

thanks,

greg k-h
