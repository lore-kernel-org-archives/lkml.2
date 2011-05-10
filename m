Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab1EJQsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:48:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50218 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1EJQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MsBX+bqehSUKgRNuxMTFZWCXYK39L86WSF1ZB1Mt6sLgk5KBznWpkQhkTW5KTjPwHU
         BbhdMv9+YVVOEakpwhMfLuYC6C8fQ0r7SejqiUFqBp6bEM0yvUdAKY5FPqfu87/gpCKw
         napkVIaBqErXTu+KjT7d9JhPr7WXcw5jJrVak=
Date: Tue, 10 May 2011 18:48:36 +0200
From: Tejun Heo <tj@kernel.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1556 disk_clear_events+0xdc/0xf0()
Message-ID: <20110510164836.GZ1661@htj.dyndns.org>
References: <20110406212611.GA5131@sucs.org>
 <20110406213718.GA14139@mtj.dyndns.org>
 <20110409093449.GA10016@sucs.org>
 <20110410145920.GA3408@sucs.org>
 <20110413200000.GG3987@mtj.dyndns.org>
 <20110415090118.GA3315@mtj.dyndns.org>
 <20110415182006.GA15916@mtj.dyndns.org>
 <20110415214140.GB1295@sucs.org>
 <20110421173845.GE15988@htj.dyndns.org>
 <20110421184304.GH15988@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421184304.GH15988@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 08:43:04PM +0200, Tejun Heo wrote:
> On Thu, Apr 21, 2011 at 07:38:45PM +0200, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Apr 15, 2011 at 10:41:40PM +0100, Sitsofe Wheeler wrote:
> > > I couldn't reproduce the problem with the very latest kernel but here's
> > > the output that appeared with an older kernel with your patch:
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: at block/genhd.c:1561 disk_clear_events+0x164/0x170()
> > 
> > Hmmm... that's really weird.  It indicates that the workqueue command
> > sequence there doesn't guarantee scheduling and completion of the work
> > item, which means either there's a bug in workqueue itself or I'm
> > confused about what's going on.  Hopefully, the latter.
> > Unfortunately, even with physical setup, I'm having problem
> > reproducing the problem.  Which kernel version are you using exactly?
> > Can you please let me know the commit ID?
> 
> Also, please try the following patch.  It should show what's going on
> with the flush machinery.

Never mind.  I now have a reliably reproducible test case.  Can you
please add yourself to bug 34662?  Let's track this issue there.

 https://bugzilla.kernel.org/show_bug.cgi?id=34662

Thanks.

-- 
tejun
