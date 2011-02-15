Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1BOQlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:41:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62019 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1BOQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=onho6QNLILcLMlGel27af+8+7jqCrLX6qMdcHyS/nCBxjaobBo1tMcYjOZMo59WXvp
         J7mrExjkgbDl3K1I7oNmvqwlwbgTyg1r2WPlBtcoxvvb68vwHlXWtG7SS/MwbHFTFdFL
         WbmcWbkLaw/4EQ8AA9LN+xlqazXwPztPw3vaE=
Date: Tue, 15 Feb 2011 17:41:28 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110215164128.GQ3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
 <20110215155018.GM3160@htj.dyndns.org>
 <4D5AA45C.7050600@redhat.com>
 <20110215161228.GN3160@htj.dyndns.org>
 <4D5AAB8F.50901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AAB8F.50901@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 15, 2011 at 05:36:31PM +0100, Milan Broz wrote:
> Well, I am also not sure about that.
> 
> But the problem is that read-write open fails now while it worked before.
> (TBH I have no idea when that EROFS fallback worked - because the code
> opened device RW, issued EROGET ioctl and set read-only... for years.)
> 
> Anyway I think EROFS is used on block devices, just grep kernel source.

Ah, okay, so the fallback was there just in case.  It didn't really
trigger and right it wouldn't have triggered until now, so your
assertion about how many programs would break is kinda bogus.  You
just have single isolated case which hasn't been excercised till now.
There may as well be code pieces which check against EACCES or what
not.

That said, maybe -EROFS is the better fit.  I really have no idea.
Maybe we should just revert and leave rw accesses to ro block devices
alone.  Jens, what do you think?

Thanks.

-- 
tejun
