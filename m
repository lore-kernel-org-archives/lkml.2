Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab1CDLIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:08:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49744 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1CDLIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BO6VsTPKIZ5H/VV4xPAHYC276tbyJVY+Q5/py/U5fe5MvCwsfDUMCs9JhzQrO7ELsp
         HakbtJ5m4k2rGm91n5+5KFvqN+djO6wJ3k8Q0kuyO+bPs9OUicxxvtzYqudBMI0MtLpm
         zFmi9VoNK3s2eLjltEwA9GeXJ1E4Rbc0AHmVk=
Date: Fri, 4 Mar 2011 12:07:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Cc: Mark Lord <kernel@teksavvy.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: NEC ND-4550A problems reading DVD-R
Message-ID: <20110304110757.GJ20499@htj.dyndns.org>
References: <m339n7g7tw.fsf@intrepid.localdomain>
 <20110301080153.GA26074@htj.dyndns.org>
 <4D6CF92A.4020105@teksavvy.com>
 <4D6D151D.8030307@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6D151D.8030307@earthlink.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens and James)

On Tue, Mar 01, 2011 at 10:47:41AM -0500, Stephen Clark wrote:
> On 03/01/2011 08:48 AM, Mark Lord wrote:
> >On 11-03-01 03:01 AM, Tejun Heo wrote:
> >..
> >>I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
> >>hardcoded to be 30 seconds.  Maybe it's better to move it to use the
> >>block parameter.  Anyways, the drive actually takes longer than 30secs
> >>to recognize the media?
> >That slow behaviour is not uncommon, especially as drives struggle
> >to recognize various forms of copy-protected media (DVD-Video).
> >A longer default, or tuneable timeout, would help.
>
> I agree with Mark, this should be a user tuneable value. My 2006 LG
> dvd-rw frequently times out
> trying to identify the media. But after numerous timeout error
> messages it usually suceeds.

I don't think it should be a user tunable value.  It should be
something automatic.  I mean, how many would know to go some cryptic
place and increase sr probing timeout?

At the same time, increasing it for other cases is quite unattractive,
so it probably would be a good idea to only use higher timeout value
for the TUR right after media presence change event.

Anyone interested in doing it?

Thanks.

-- 
tejun
