Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1FMWXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:23:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab1FMWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:23:46 -0400
Date: Mon, 13 Jun 2011 15:23:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] bdi write bandwidth estimation
Message-Id: <20110613152330.056e2eba.akpm@linux-foundation.org>
In-Reply-To: <20110612151821.601514494@intel.com>
References: <20110612151821.601514494@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 23:18:21 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Do bdi write bandwidth estimation in the flusher thread at 200ms intervals,

stdrant: anything which is paced using "seconds" is basically always
wrong.  The bandwidth of storage systems varies by who-knows-how-many
orders of magnitude.  If 200ms is correct for one system then it is
vastly incorrect for another.

A more suitable clock for this estimate would be "per 200 requests",
for a block-based BDI.

Also of course the bandwidth of a particular BDI varies vastly
depending on workload.  For the purpose of this work, that's probably
a desirable thing.

