Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304Ab2LGA5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:57:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49507 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423263Ab2LGA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:57:45 -0500
Message-ID: <1354841855.3026.7.camel@thor>
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 06 Dec 2012 19:57:35 -0500
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 02:07 -0500, Peter Hurley wrote:
> This patch series addresses the causes of flush_to_ldisc accessing
> the tty after freeing.

Well, there's going to be a v2 of this series.

Sasha found that PATCH 3/9 is an insufficient fix. I've already worked
out the correct solution but I've been plagued by the kswapd/flush
problem so that's making this more challenging then it ought to be.

Plus I tripped across a GP fault in the SLUB allocator which turns out
to be a free list corruption (probably because of the low memory
condition brought on by the kswapd problem. Good times...)

There is also going to be a v3 because I just came up with an idea to
clean up the whole ldisc ref situation, but I'm going to take some time
testing it out first.

Anyway, just wanted to hold this off for another respin.

Regards,
Peter Hurley

