Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1GMC24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 22:28:56 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53120 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693Ab1GMC2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 22:28:54 -0400
X-Sasl-enc: NRcBfypr/vVzKsJ+YXgE6SSp8eNRfUoWMd1VvRyhiS9L 1310524133
Date: Wed, 13 Jul 2011 04:26:19 +0200
From: Greg KH <greg@kroah.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, helge.hafting@hist.no
Subject: Re: [stable] [PATCH] cifs: fix wsize negotiation for 2.6.39 stable
Message-ID: <20110713022619.GA11043@kroah.com>
References: <1310520281-17467-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310520281-17467-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:24:41PM -0400, Jeff Layton wrote:
> I sent this a week or so ago, but it apparently missed the recent
> 2.6.39.y release. Resending to make sure it gets into the next one.
> 
> Prior to 2.6.39, when signing was enabled on a socket the client only
> sent single-page writes. This changed with commit ca83ce3d5b, which
> made signed and unsigned connections use the same codepaths for write
> calls.
> 
> This caused a regression when working with windows servers. Windows
> machines will reject writes larger than the MaxBufferSize when signing
> is active, but does not clear the CAP_LARGE_WRITE_X flag in the
> negotiation.
> 
> This patch backports 2 patches that fix this problem in 3.0 kernels,
> and changes a couple of the constants to values appropriate for the
> writeback code in 2.6.39.

Why not just tell me the 2 patches in upstream that need to be
backported as Documentation/stable_kernel_rules.txt say to do instead?

thanks,

greg k-h
