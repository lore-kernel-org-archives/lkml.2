Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1BOPu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:50:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58217 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1BOPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a4UhKHaajuyfPEFHOYomzQcR2fEu/rBNY+YYZghGlvPW92r+63As9nfuF4O/ij1cYG
         AmXeH+MsMhwKl3MVD4b/JjiR8rSb2w5h1FNOMRWQa+G9sfNomRNFpR49+zILvHNJ+vf5
         MXGk9mSBXOnV54thRkOVRkxe4fiN8JuHgBemo=
Date: Tue, 15 Feb 2011 16:50:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Message-ID: <20110215155018.GM3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
 <20110215152033.GK3160@htj.dyndns.org>
 <20110215154625.GG5825@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215154625.GG5825@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 15, 2011 at 03:46:25PM +0000, Alasdair G Kergon wrote:
> Exactly:)  If the filesystem permissions were what was blocking this
> (say r--) then I'd agree with EACCES.  Interpret those man pages in the
> context of 'pathname refers to a block device not a file'.
>  
> If it's EACCES, I just need to gain more privilege/capabilities and then
> repeat the system call and it could succeed.
> 
> But EROFS tells me however much extra privilege I get it's going to make
> no difference.
> 
> That's why I'm arguing EACCES is not a good error to return and EROFS is
> more appropriate.

Frankly, I don't really mind one way or the other but EROFS isn't
usually used in those areas.  It might make sense for this use case
and then there will be cases it just feels awkward.  This being a dm
thing, wouldn't it be just better to let dm massage the return value?

Thanks.

-- 
tejun
