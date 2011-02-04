Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1BDPIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:08:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55327 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1BDPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:08:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TG9aqcihaF8Cp8MF5pfvWuA1F97P3DJg97D4O0DGcKMd2pnsdGTCvN6UDlj1u3vGLY
         nAY4gbrb7MS4dp7KSFefMjorZ6f3VjOD5zqOMJJGxLrmA0IGHsB4nw0GGOmNxXLkgrFC
         YGUMGYajMQCJFz9VPt43Ak1KOF33P57+Wh7j0=
Date: Fri, 4 Feb 2011 16:08:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
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
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Message-ID: <20110204150826.GJ12133@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
 <20110203133820.GF2570@htj.dyndns.org>
 <20110204150456.GD32190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204150456.GD32190@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 04, 2011 at 10:04:57AM -0500, Vivek Goyal wrote:
> > The rationale behind suggesting was that it indicates to the allocator
> > that the request may be sorted as how the request will be used is
> > communicated using @rw_flags to the allocator.  The patch is buggy
> > that the flag actually ends up on the request.  Any better idea how to
> > communicate it?
> 
> Though you did not like the V1 of patch, personally I also liked just parsing
> FLUSH or FUA flag in get_request().
> 
> Or how about intoducing a helper function blk_rq_should_init_elevator() 
> or something like that and this function will parse FLUSH, FUA flags.

I suppose it's Jens' call, but if the FLUSH/FUA testing goes inside
the alloc function, please decorate with big fat comment and mention
it in the comment for the union definition too.

Thank you.

-- 
tejun
