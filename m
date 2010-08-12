Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab0HLN1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759847Ab0HLN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:27:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2] MD: raid, fix BUG caused by flags handling
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Aug 2010 09:26:30 -0400
In-Reply-To: <1281616266-4709-1-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:04 +0200")
Message-ID: <x49mxss3qt5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Commit 74450be1 (block: unify flags for struct bio and struct request)
> added direct test of flags in the & form:
>   const bool do_sync = (bio->bi_rw & REQ_SYNC);
> But this doesn't fit into bool with my compiler (gcc 4.5). So change
> the type to ulong to avoid the bug.

At first I wondered why you didn't use the !! trick, but after looking
at the code, I see that the result is |'d into bi_rw.

Looks good.  Sounds like it might have been a real bear to track down.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
