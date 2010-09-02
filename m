Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0IBCU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0IBCU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:20:26 -0400
Date: Wed, 1 Sep 2010 22:20:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Nauman Rafique <nauman@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Divyesh Shah <dpshah@google.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] cfq-iosched: add cfq group hierarchical scheduling
 support
Message-ID: <20100902022008.GA7901@redhat.com>
References: <4C7B54C0.7080008@cn.fujitsu.com>
 <20100830203644.GA15903@redhat.com>
 <4C7C4CE0.5080402@cn.fujitsu.com>
 <20100831125737.GA2527@redhat.com>
 <AANLkTi=daFyrx+ts4DoAHwR8EHUfF0nYyv45zJkBFm--@mail.gmail.com>
 <20100831192524.GD2527@redhat.com>
 <4C7E13CE.7070603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C7E13CE.7070603@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 04:50:22PM +0800, Gui Jianfeng wrote:

[..]

> Hi Vivek，
> 
> Even if we mount cpu and blkio together, to me, it's ok for cpu and blkio
> having their own logic, since they are totally different cgroup subsystems.
> 
> > 
> > - To me, both group and cfq queue are children of root group and it
> >   makes sense to treat them independent childrens instead of putting
> >   all the queues in one logical group which inherits the weight of
> >   parent.
> > 
> > - With this new scheme, I am finding it hard to visualize the hierachy.
> >   How do you assign the weights to queue entities of a group. It is more
> >   like a invisible group with-in group. We shall have to create new
> >   tunable which can speicy the weight for this hidden group.
> 
> For the time being, the root "qse" weight is 1000 and others is 500, they don't
> inherit the weight of parent. I was thinking that maybe we can determine the qse
> weight in term of the queue number and weight in this group and subgroups. 

If you decide queue weight in terms of queue number, then you are back to
the same problem Nauman was mentioning that share of a group is not fixed
and depends on number of queues in the group.

Vivek
