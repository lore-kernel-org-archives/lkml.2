Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2CGPwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:52:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60670 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab2CGPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:52:07 -0500
Date: Wed, 7 Mar 2012 07:45:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum
 (v3)
Message-ID: <20120307154517.GA16080@kroah.com>
References: <1331117396-11600-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331117396-11600-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:49:56PM +0400, Andrew Vagin wrote:
> The queue handling in the udev daemon assumes that the events are
> ordered.
> 
> Before this patch uevent_seqnum is incremented under sequence_lock,
> than an event is send uner uevent_sock_mutex. I want to say that code
> contained a window between incrementing seqnum and sending an event.

Is this something that you have seen "in the wild"?  If so, we should
backport it to older kernels as well, right?

thanks,

greg k-h
