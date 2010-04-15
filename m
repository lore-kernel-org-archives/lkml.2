Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0DOWxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 18:53:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757871Ab0DOWxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 18:53:13 -0400
Date: Thu, 15 Apr 2010 15:53:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Taras Glek <tglek@mozilla.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-Id: <20100415155309.2649a29b.akpm@linux-foundation.org>
In-Reply-To: <4BBA6776.5060804@mozilla.com>
References: <4BBA6776.5060804@mozilla.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Apr 2010 15:43:02 -0700
Taras Glek <tglek@mozilla.com> wrote:

> To make matters worse, 
> the compile-time linker + gcc lay out code in a manner that does not 
> correspond to how the resulting executable will be executed(ie the 
> layout is basically random).

Yes, the linker scrambles the executable's block ordering.

This just isn't an interesting case.  World-wide, the number of people
who compile their own web browser and execute it from the file which ld
produced is, umm, seven.

So I'd suggest that you always copy the executable to a temp file and
mv it back before running any timing tests.

