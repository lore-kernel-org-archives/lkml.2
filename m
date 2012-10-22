Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2JVXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:33:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33156 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2JVXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:33:54 -0400
Date: Mon, 22 Oct 2012 16:33:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: 3.7 RC1
Message-ID: <20121022233351.GA6589@kroah.com>
References: <1350949065-24655-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350949065-24655-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 04:37:45PM -0700, K. Y. Srinivasan wrote:
> 
> While testing 3.7 RC1 I discovered that invoking the function orderly_poweroff()
> from an interrupt context will trigger an ASSERT(). This was not the case till
> recently. The comment preceding the orderly_poweroff() function claims that this
> function can be invoked from any context and in the current Hyper-V util driver,
> we support host-driven orderly shut down of the guest by invoking this
> orderly_poweroff() function in the context of the message callback. This code has
> been working for a very long time and it is broken now. Is my assumption that
> orderly_poweroff() could be invoked from the interrupt context a wrong assumption?

Can you check 3.7-rc2?  If that also fails, care to do a 'git bisect'
from 3.6 to 3.7-rc1 to find the problem patch?

thanks,

greg k-h
