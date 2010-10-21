Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0JUWnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:43:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab0JUWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:43:40 -0400
Date: Thu, 21 Oct 2010 15:43:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021154333.f67fd870.akpm@linux-foundation.org>
In-Reply-To: <1287238754.2799.376.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010 16:19:14 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> The current way to change a percpu_counter is to call
> percpu_counter_add(), which is a bit expensive.
> (More than 40 instructions, possible false sharing, ...)

This is incorrect.  With my compiler it's 25 instructions except in the
very rare case where a batch overflow occurs.

And more than half of that is function call entry/exit overhead.

