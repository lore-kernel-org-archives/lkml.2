Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab2IGXOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab2IGXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:14:44 -0400
Date: Sat, 8 Sep 2012 00:14:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <koverstreet@google.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v10 4/8] block: Add bio_reset()
Message-ID: <20120907231433.GE10309@agk-dp.fab.redhat.com>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>,
	Kent Overstreet <koverstreet@google.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-5-git-send-email-koverstreet@google.com> <50494F1A.4080207@kernel.dk> <20120907205823.GD16360@google.com> <504A6D57.1030607@kernel.dk> <504A6FF5.3090603@kernel.dk> <20120907222522.GE16360@google.com> <504A78B0.8010105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504A78B0.8010105@kernel.dk>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I indicated already in this discussion, dm started to use
merge_bvec_fn as a cheap way of avoiding splitting and this improved
overall efficiency.  Often it's better to pay the small price of calling
that function to ensure the bio is created the right size in the first
place so it won't have to get split later.

I'm as yet unconvinced that removing merge_bvec_fn would be an overall
win.  Some of Kent's other changes that make splitting cheaper will
improve the balance in some situations, but that might be handled by
simplifying the merge_bvec_fn calculations in those situations.
(Or changing the mechanism to avoid repeating performing the mapping
when it hasn't changed.)

IOW Any proposal to remove merge_bvec_fn from dm needs careful 
evaluation to ensure it doesn't introduce any significant
performance regressions for some sets of users.

Alasdair

