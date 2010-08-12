Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0HLQGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:06:44 -0400
Received: from verein.lst.de ([213.95.11.210]:44857 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841Ab0HLQGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:06:41 -0400
Date: Thu, 12 Aug 2010 18:06:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] SCSI: fix bio.bi_rw handling
Message-ID: <20100812160630.GB28689@lst.de>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-2-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281616266-4709-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:31:05PM +0200, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. So
> testing against constants doesn't make sense anymore. Fix this bug in
> osd_req_read by removing "== 1" in test.
> 
> This is not a problem now, where REQ_WRITE is 1, but this can change
> in the future and we don't want to rely on that.

And it's much cleaner anyway.  Note that I think we particularly need
the WARN_ON anyway.


Reviewed-by: Christoph Hellwig <hch@lst.de>

