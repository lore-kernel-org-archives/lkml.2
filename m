Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0GFPdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:33:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55802 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0GFPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:33:14 -0400
Subject: Re: [PATCH] memory hotplug disable boot option
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4C3349BF.7030104@austin.ibm.com>
References: <20100628154455.GA13918@suse.de>
	 <1277769867.8354.531.camel@nimitz>
	 <20100629115232.38BC.A69D9226@jp.fujitsu.com>
	 <1277827384.8354.3413.camel@nimitz>	<20100629180415.GB1240@suse.de>
	 <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100630154755.GB12158@suse.de>
	 <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
	 <1277990595.8354.10356.camel@nimitz>  <4C3349BF.7030104@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 06 Jul 2010 08:33:05 -0700
Message-ID: <1278430385.8354.23957.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 10:20 -0500, Nathan Fontenot wrote:
> On 07/01/2010 08:23 AM, Dave Hansen wrote:
> > 
> > I was thinking more along the lines of just taking adjacent sections and
> > merging them.  We'll need a new "end address" or size file.  Maybe
> > "end_phys_index" or something similar.
> > 
> > Such a beast would not fix all of the pathological cases, like where
> > only every other 16MB section is populated with RAM, but I don't think
> > those are very common at all, especially in cases where there's a lot of
> > RAM.  But, it also has a chance of being relatively backward-compatible.
> > In most cases, we may even be able to calculate a new phys_block_size
> > where everything fits evenly and be fully backward-compatible with the
> > old ABI.
> 
> Under this scenario were you thinking that all of the memory sections that
> reside under this memory block would then be acted upon as a whole.  For
> example would we allow users to hotplug individual memory sections included
> in th block, or would the memory block be acted upon as a whole?

I think we would need a mechanism that allowed the sysfs directories to
be broken down somehow.  If the merging is very successful, it could
lead to a case where no existing sysfs dir is a reasonable size to
remove.  That's what we'd have to avoid, so I think we'd _need_
splitting of some kind.


-- Dave

