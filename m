Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0KRKnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:43:17 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53599 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab0KRKnP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:43:15 -0500
X-AuditID: 1209190c-b7ba9ae0000009f8-3e-4ce5034294ba
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20101118054629.GA3339@amd>
Date: Thu, 18 Nov 2010 05:43:06 -0500
Cc: Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2ADBEB7E-0EC8-4536-B556-0453A8E1D5FA@mit.edu>
References: <1289996638-21439-1-git-send-email-walken@google.com> <1289996638-21439-4-git-send-email-walken@google.com> <20101117125756.GA5576@amd> <1290007734.2109.941.camel@laptop> <20101118054629.GA3339@amd>
To: Nick Piggin <npiggin@kernel.dk>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 18, 2010, at 12:46 AM, Nick Piggin wrote:

> The right way to fix this would not be to introduce the new regression
> but either/both: a specific syscall to mlock-for-read which does not do
> any reservations, fix filesystem hook to allow reservation without
> implying dirtying. A simple flag to page_mkwrite will be enough (plus
> the logic to call it from VM).

Why is it at all important that mlock() force block allocation for sparse blocks?    It's  not at all specified in the mlock() API definition that it does that.

Are there really programs that assume that mlock() == fallocate()?!?

-- Ted


