Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab1F1SXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:23:33 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45565 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423Ab1F1SWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:22:00 -0400
X-Sasl-enc: pO5tjQoVdBRY55ZfCY9phF91dXF5aIL9ZqBeIte88wzN 1309285320
Date: Tue, 28 Jun 2011 11:12:15 -0700
From: Greg KH <greg@kroah.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org
Subject: Re: [PATCH 2/2] AppArmor: Fix masking of capabilities in complain
 mode
Message-ID: <20110628181215.GA15843@kroah.com>
References: <1309276565-20776-1-git-send-email-john.johansen@canonical.com>
 <1309276565-20776-3-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309276565-20776-3-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 04:56:05PM +0100, John Johansen wrote:
> AppArmor is masking the capabilities returned by capget against the
> capabilities mask in the profile.  This is wrong, in complain mode the
> profile has effectively all capabilities, as the profile restrictions are
> not being enforced, merely tested against to determine is an access is
> known by the profile.
> 
> This can result in the wrong behavior of security conscience applications
> like sshd which examine their capability set, and change their behavior
> accordingly.  In this case because of the masked capability set being
> returned sshd fails due to DAC checks, even when the profile is complain
> mode.
> 
> Kernels affected: 2.6.36 - 3.0
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

As this should probably go to the stable tree, next time care to add a
simple:
	Cc: stable <stable@kernel.org>
to the signed-off-by: area of the patch so it gets automagically
included in the stable and longterm kernels as needed when it hits
Linus's tree?

thanks,

greg k-h
