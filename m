Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0HWWLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:11:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab0HWWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:11:39 -0400
Date: Mon, 23 Aug 2010 15:11:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
Message-Id: <20100823151129.433875d9.akpm@linux-foundation.org>
In-Reply-To: <20100823220347.GB3380@quack.suse.cz>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
	<20100817095103.GA3557@quack.suse.cz>
	<20100823122813.1ffa3f2e.akpm@linux-foundation.org>
	<20100823220347.GB3380@quack.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 00:03:47 +0200
Jan Kara <jack@suse.cz> wrote:

> So do
> you think that we should keep __GFP_NOFAIL as long as all callers are not
> able to handle allocation failures in more reasonable way?

The concept should be encapsulated in _some_ centralised fashion.

Helper functions would work as well as __GFP_NOFAIL, and will move any
runtime cost away from the good code and push it onto the bad code.

