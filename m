Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2JXQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:54:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50971 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2JXQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:54:57 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH v4 2/2] block: Convert integrity to bvec_alloc_bs()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-29-git-send-email-koverstreet@google.com>
Date: Wed, 24 Oct 2012 12:54:49 -0400
In-Reply-To: <1350331769-14856-29-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Mon, 15 Oct 2012 13:09:02 -0700")
Message-ID: <yq1ip9zbyjq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

Kent> Also, bio_integrity_alloc() was using fs_bio_set if no bio_set was
Kent> specified. This was wrong

You did that, I didn't.


Kent> - using the bio_set doesn't protect us from memory allocation
Kent>   failures, because we just used kmalloc for the
Kent>   bio_integrity_payload.

I don't understand this comment. kmalloc where?

The bip includes an embedded bvec array and comes from either one of the
dedicated slabs or - in the case of the max bvec size - from a
mempool. These slabs and the mempool are per bio_set.

-- 
Martin K. Petersen	Oracle Linux Engineering
