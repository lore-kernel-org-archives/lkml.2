Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab0GBQPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:15:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50162 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759072Ab0GBQPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:15:33 -0400
Subject: Re: [PATCH] memory hotplug disable boot option
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100628154455.GA13918@suse.de>
	 <1277769867.8354.531.camel@nimitz>
	 <20100629115232.38BC.A69D9226@jp.fujitsu.com>
	 <1277827384.8354.3413.camel@nimitz>	<20100629180415.GB1240@suse.de>
	 <20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100630154755.GB12158@suse.de>
	 <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 01 Jul 2010 06:23:15 -0700
Message-ID: <1277990595.8354.10356.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 09:31 +0900, KAMEZAWA Hiroyuki wrote:
> 
> Considering briefly, how about this compact layout ?
> 
> /sys/devices/system/memory/:
>                             list, hide, show, memoryX...
> 
> list: // show available memory index list.
>   #cat list
>    0 1 2 ....10000...
> 
> show: //an interface to enable the interface.
>   #echo INDEX > memory_index
>   will create memoryINDEX diretory.
> 
> hide: //an interface to hide the interface.
>   #echo INDEX > memory_hide
>   will remove memoryINDEX sysfs directory.

I was thinking more along the lines of just taking adjacent sections and
merging them.  We'll need a new "end address" or size file.  Maybe
"end_phys_index" or something similar.

Such a beast would not fix all of the pathological cases, like where
only every other 16MB section is populated with RAM, but I don't think
those are very common at all, especially in cases where there's a lot of
RAM.  But, it also has a chance of being relatively backward-compatible.
In most cases, we may even be able to calculate a new phys_block_size
where everything fits evenly and be fully backward-compatible with the
old ABI.

-- Dave

