Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1AMN0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1AMN0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:26:47 -0500
Date: Thu, 13 Jan 2011 14:26:37 +0100
From: Karel Zak <kzak@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
	bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113132637.GH16523@nb.net.home>
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113110640.GC30719@htj.dyndns.org> <4D2EE156.1050006@redhat.com> <20110113122701.GG16523@nb.net.home> <20110113131216.GF30719@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113131216.GF30719@htj.dyndns.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:12:16PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 13, 2011 at 01:27:01PM +0100, Karel Zak wrote:
> >  We also use holders/slaves links in libblkid to evaluate dependencies
> >  between devices (since 2008).
> > 
> > > Whatever changes are needed, please keep this functionality, it
> > > can be useful.
> > 
> >  Definitely.
> 
> Yeah, sure, it's not like I can afford to avoid fixing it at this
> point anyway, but I still want to point out it's at the wrong layer
> and shouldn't have been added like this, really.  If you want blkid to
> identify it, the proper thing to do would be querying blk device for
> the claimer and then use claimer-specific method to query them.  It's

 It seems that dependencies (holders/slaves) between devices is pretty
 generic thing. Why do you think that we need claimer-specific method?
 The /sys filesystem is better that ictls in many ways.

> not like the current method would make sense for btrfs or whatnot.

 Could you be more verbose, please?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
