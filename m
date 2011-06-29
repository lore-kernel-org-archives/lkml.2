Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1F2PQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:16:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47863 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab1F2PQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:16:08 -0400
X-Sasl-enc: MFZlGeuk9YbJ3pZf5019xq39tmloq+NiVnU81Ewsxk6K 1309360566
Date: Wed, 29 Jun 2011 08:05:54 -0700
From: Greg KH <greg@kroah.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] AppArmor: Fix masking of capabilities in complain
 mode
Message-ID: <20110629150554.GA18023@kroah.com>
References: <1309311874-23262-1-git-send-email-john.johansen@canonical.com>
 <1309311874-23262-3-git-send-email-john.johansen@canonical.com>
 <20110629042440.GC18344@kroah.com>
 <4E0ADA66.9070004@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0ADA66.9070004@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 08:55:18AM +0100, John Johansen wrote:
> On 06/29/2011 05:24 AM, Greg KH wrote:
> > On Wed, Jun 29, 2011 at 02:44:34AM +0100, John Johansen wrote:
> >> AppArmor is masking the capabilities returned by capget against the
> >> capabilities mask in the profile.  This is wrong, in complain mode the
> >> profile has effectively all capabilities, as the profile restrictions are
> >> not being enforced, merely tested against to determine if an access is
> >> known by the profile.
> >>
> >> This can result in the wrong behavior of security conscience applications
> >> like sshd which examine their capability set, and change their behavior
> >> accordingly.  In this case because of the masked capability set being
> >> returned sshd fails due to DAC checks, even when the profile is in complain
> >> mode.
> >>
> >> Kernels affected: 2.6.36 - 3.0.
> >>
> >> Signed-off-by: John Johansen <john.johansen@canonical.com>
> >> ---
> > 
> > You say that multiple kernels are affected, then why not also include
> > stable@kernel.org here as well?
> > 
> > confused,
> > 
> Sorry I should have elaborated, I think its a borderline case for stable
> release, and was as much a note to my self as anything.

Notes to self probably shouldn't be in kernel changelog entries :)

> The bug doesn't affect the enforcement of policy, only learning mode used
> for generating policy, and it is something we can work around in userspace.
> for already released kernels.
> 
> I can resend with a Cc: stable if you would like

If you don't think it should be in the stable kernel releases, that's
fine, you are the maintainer of the code.  I just found it odd that you
said it affected older kernels and yet didn't want it applied there as
well.

greg k-h
