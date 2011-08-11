Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1HKT6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:58:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1HKT6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:58:09 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Date: Thu, 11 Aug 2011 21:57:28 +0200
In-Reply-To: <CAAuSN92aJ2unHgSDi-385ejbEsRHTavxi11cnL_z806a6Z+FZw@mail.gmail.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	 <1313091791.8491.33.camel@twins>
	 <CAAuSN92aJ2unHgSDi-385ejbEsRHTavxi11cnL_z806a6Z+FZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313092648.26866.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:51 -0700, Alex Neronskiy wrote:
> I didn't want to hold on to a lock while the lines were iterated over,
> and instead just dump it in one go. I guess it's not a big deal to do
> that, though. Nonetheless, is one page not enough? 

The "[<%pK>] %pS\n" that's 6bytes + 8bytes + ~64bytes making 78 bytes at
worst (assuming we have a symbol length max of 64 that is), that yields
4096/78 = 52, so yeah, just about enough since your trace depth is
limited at 50. But its close enough to make me feel uncomfortable.


