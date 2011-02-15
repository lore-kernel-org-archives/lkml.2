Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1BOQNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:13:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61501 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1BOQNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MGB9FCmKEe2MALXcr1xo7iKWpYyO8XNudxECeC5ceZacVIPhrtlybGPCeKC94AwJwf
         B/dlbyhADxmqB92SASwFc2ZpvtGHFJJz9OXTjd71wyNiH8QUKL4p9uYQ0iipFFy5+iu0
         iFxqkFvdt8Qd3Bb3laGF3ieYhB6wZDtc31YB8=
Date: Tue, 15 Feb 2011 17:12:28 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110215161228.GN3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AA45C.7050600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:05:48PM +0100, Milan Broz wrote:
> On 02/15/2011 04:50 PM, Tejun Heo wrote:
> >> That's why I'm arguing EACCES is not a good error to return and EROFS is
> >> more appropriate.
> > 
> > Frankly, I don't really mind one way or the other but EROFS isn't
> > usually used in those areas.  It might make sense for this use case
> > and then there will be cases it just feels awkward.  This being a dm
> > thing, wouldn't it be just better to let dm massage the return value?
> 
> It is not DM thing. That code was checking for generic block device.
> No DM there (it was from cryptsetup code but not related to DM part).

Hmmm... I'm confused now.  Where was that -EROFS from then?  I don't
recall changing -EROFS to -EACCES.  What did I miss?

-- 
tejun
