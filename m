Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2CGF4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:56:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35713 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2CGF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:56:06 -0500
X-Sasl-enc: 0N7L1q7c6VWQDrECWuFJB5TsgdnkJKBtWUQcKtlZpypV 1331099708
Date: Tue, 6 Mar 2012 21:52:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "avagin@gmail.com" <avagin@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Andrew Vagin <avagin@openvz.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum
Message-ID: <20120307055206.GA8217@kroah.com>
References: <CAPXgP10GRZ6Y3+dtNSw5zQMaM9FnSBBfLrCJmQ948gA3tALtfw@mail.gmail.com>
 <1331064368-55675-1-git-send-email-avagin@openvz.org>
 <CAPXgP10qwPn2-QeyPpDy3GiEqvU6jB-wVuUOUXwcGBvOWOUA1Q@mail.gmail.com>
 <4F567E1C.80003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F567E1C.80003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:14:04AM +0400, avagin@gmail.com wrote:
> On 03/07/2012 01:03 AM, Kay Sievers wrote:
> >On Tue, Mar 6, 2012 at 21:06, Andrew Vagin<avagin@openvz.org>  wrote:
> >>
> >>The queue handling in the udev daemon assumes that the events are
> >>ordered.
> >>
> >>Before this patch uevent_seqnum is incremented under sequence_lock,
> >>than an event is send uner uevent_sock_mutex. I want to say that code
> >>contained a window between incrementing seqnum and sending an event.
> >>
> >>This patch locks uevent_sock_mutex before incrementing uevent_seqnum.
> >
> >I think we can remove the spin_lock(&sequence_lock); entirely now, right?
> 
> I thought about that too. sequence_lock is used when CONFIG_NET
> isn't defined. I've looked on this code one more time and we may
> leave only uevent_sock_mutex and use it even when CONFIG_NET isn't
> defined.
> Thanks for the comment.
> 
> Greg, do you have other objections about this patch?

Let's see the one based on Kay's comments first please.

thanks,

greg k-h
