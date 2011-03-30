Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab1C3ICL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:02:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53812 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1C3ICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gfsxHnAfKYJE6JG9zc6SALa7BxS0n85i7LR/lxtkuyjsEI9HwtAiLTG22iNJG435KI
         YPgzDEUhqBh8Zy7e11lTYd64MoPmivOMfHIhGZE90nRQZIMZ2ZBSYd4b3P3guvP+lRp1
         7YEps6PqimRBhshA67Bdl1ouquKwYNTj1pyHE=
Date: Wed, 30 Mar 2011 10:02:03 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330080203.GD17523@htj.dyndns.org>
References: <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D92E2CD.6000909@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Wed, Mar 30, 2011 at 09:59:09AM +0200, Jens Axboe wrote:
> Pure front insert should be used for requeue and internal commands (like
> spin up this drive, or get error information). Flush should append to
> the dispatch list.

Yeah, right.  The reason I used REQUEUE/FRONT was because BACK
insertion involves draining the elevator and then appending the
request at the end of the dispatch queue, which is unnecessary and
inefficient.  So, front insertion was a quick work around that.  If
we're removing elv_insert(), we can just append directly to the
dispatch queue from flush code.

Thanks.

-- 
tejun
