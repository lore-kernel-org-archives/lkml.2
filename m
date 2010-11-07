Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0KGLpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:45:50 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:59578 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0KGLpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:45:49 -0500
X-ASG-Debug-ID: 1289130348-085bb4b20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CD69163.1030407@fusionio.com>
Date: Sun, 7 Nov 2010 12:45:39 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [PATCH] block: read i_size with i_size_read()
References: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] block: read i_size with i_size_read()
In-Reply-To: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289130348
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4533 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.45935
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-05 20:27, Mike Snitzer wrote:
> Convert direct reads of an inode's i_size to using i_size_read().
> 
> i_size_{read,write} use a seqcount to protect reads from accessing
> incomple writes.  Concurrent i_size_write()s require mutual exclussion
> to protect the seqcount that is used by i_size_{read,write}.  But
> i_size_read() callers do not need to use additional locking.

Thanks Mike, I'll queue this up.

-- 
Jens Axboe

