Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0J0Xpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:45:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab0J0Xpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:45:44 -0400
Date: Wed, 27 Oct 2010 16:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Patch] Convert max_user_watches to long.
Message-Id: <20101027164502.d6e2068d.akpm@linux-foundation.org>
In-Reply-To: <20101027190921.059806977@gulag1.americas.sgi.com>
References: <20101027190914.146006767@gulag1.americas.sgi.com>
	<20101027190921.059806977@gulag1.americas.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 14:09:15 -0500
Robin Holt <holt@sgi.com> wrote:

> On a 16TB machine, max_user_watches has an integer overflow.  Convert it
> to use a long and handle the associated fallout.
> 

hand-wavy reality check:

Are the existing defaults sane?  How well does the code perform with a
few billion watches?

Is the expected use case one-watch-per-user-per-fd?  If so, then
perhaps the max number of user_watches should have some realtionship
with the max number of fds?

