Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0FAViq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:38:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0FAVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:38:44 -0400
Date: Tue, 1 Jun 2010 17:37:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
       Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Douglas Gilbert <dgilbert@interlog.com>, Ingo Molnar <mingo@redhat.com>,
       John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace BKL with global mutex
Message-ID: <20100601213755.GA1004@infradead.org>
References: <1275428028-10901-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275428028-10901-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.  You're really only creation a mini-BKL here without
sorting out the locking.  Please go through the individual
callers and sort them out.  Start by pushing the remaining
ioctls to the unlocked version and moving the BKL into the
->open and ->release methods.

