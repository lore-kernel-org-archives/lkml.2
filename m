Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1GEQPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:15:06 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59415 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab1GEQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:15:04 -0400
X-Sasl-enc: k9rQEvlavgeUWmT2SjtZdOCiF6NmoHK/WVYnC5T4R5rX 1309882503
Date: Tue, 5 Jul 2011 09:10:07 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH 5/5] staging: hv: fix a kernel warning in
 netvsc_linkstatus_callback()
Message-ID: <20110705161007.GA24332@kroah.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
 <1308322688-9796-5-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322688-9796-5-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:58:08AM -0700, Haiyang Zhang wrote:
> netif_notify_peers() is not allowed in netvsc_linkstatus_callback() on some
> distros,

"distros"?  Huh?  You mean kernel versions right?

And this doesn't matter for the current kernel, right?  If not, then it
doesn't need to be applied.  If so, then it should.  Which is it?

> because netvsc_linkstatus_callback() is within IRQ context. So we
> move the first call to netif_notify_peers() into queued work as well, but with
> zero delay.

What happens if you don't have this patch applied?  What breaks?  Is it
just a warning?  Something else?

Please resend this with more information.

greg k-h
