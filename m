Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0HWUB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:01:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621Ab0HWUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:01:55 -0400
Date: Mon, 23 Aug 2010 13:01:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Message-Id: <20100823130109.6da43a58.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hows about you add a helper function

	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)

then convert the callsites to use that, then nuke __GFP_NOFAIL?
