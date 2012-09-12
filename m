Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2ILTjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:39:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35681 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2ILTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:39:29 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        tj@kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(), and a bugfix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-2-git-send-email-koverstreet@google.com>
	<20120911203643.GC17113@redhat.com>
	<20120911220750.GM19739@google.com>
Date: Wed, 12 Sep 2012 15:39:18 -0400
In-Reply-To: <20120911220750.GM19739@google.com> (Kent Overstreet's message of
	"Tue, 11 Sep 2012 15:07:50 -0700")
Message-ID: <yq1wqzzrpy1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

Kent,

Kent> To fix the bug first, I'd have to reorder struct bio_pair and then
Kent> just delete two lines of code from bio_integrity_split(). But the
Kent> reordering is unnecessary with the refactoring.

Well, a bug is a bug and the fix needs to go into stable. So we will
need a patch that does not depend on your changes.

I don't have a problem with adding a pointer so clones can point to the
parent's vector. But embedding the vector into the bip was a feature.
If you check the git log you'll see that originally I did use separate
vector allocations.

-- 
Martin K. Petersen	Oracle Linux Engineering
