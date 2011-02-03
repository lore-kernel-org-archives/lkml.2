Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1BCNYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:24:09 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:46774 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1BCNYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:24:08 -0500
X-ASG-Debug-ID: 1296739445-03d6a50f0b0caf0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D4AAC9A.4050407@fusionio.com>
Date: Thu, 3 Feb 2011 14:24:42 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "shli@kernel.org" <shli@kernel.org>, "neilb@suse.de" <neilb@suse.de>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kmannth@us.ibm.com" <kmannth@us.ibm.com>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "josef@redhat.com" <josef@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for flush
  requests
References: <20110201185225.GT14211@htj.dyndns.org> <1296600373-6906-1-git-send-email-snitzer@redhat.com> <20110202225549.GA28109@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v3 1/2] block: skip elevator data initialization for flush
  requests
In-Reply-To: <20110202225549.GA28109@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1296739445
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.54260
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-02 23:55, Mike Snitzer wrote:
> Set REQ_SORTED, in the @rw_flags passed to the request allocator, for
> any request that may be put on IO scheduler.  Skip elevator data
> initialization during request allocation if REQ_SORTED is not set.
> 
> REQ_SORTED is not set for flush requests because they are never put on
> the IO scheduler.

That looks very wrong. REQ_SORTED gets set _when_ the request is sorted
into the IO scheduler. This is gross misuse, a bad hack.

-- 
Jens Axboe

