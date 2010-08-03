Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab0HCWGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab0HCWGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:06:30 -0400
Subject: Re: [PATCH] flex_array: add helpers to get and put to make
 pointers easy to use
From: Eric Paris <eparis@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        dave@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        jmorris@namei.org, sds@tycho.nsa.gov
In-Reply-To: <alpine.DEB.2.00.1008031351290.13924@chino.kir.corp.google.com>
References: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
	 <alpine.DEB.2.00.1008031351290.13924@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 18:05:46 -0400
Message-ID: <1280873146.23348.7.camel@dhcp231-200.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 13:55 -0700, David Rientjes wrote:
> On Tue, 3 Aug 2010, Eric Paris wrote:
> 
> > Getting and putting arrays of pointers with flex arrays is a PITA.  You
> > have to remember to pass &ptr to the _put and you have to do weird and
> > wacky casting to get the ptr back from the _get.  Add two functions
> > flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.
> > 
> 
> There's no code currently in the tree that uses the flex array interface, 
> so is this something that you've encountered in practice or only by 
> inspection?  If it's the former, is that code on its way for 2.6.36?

I did decide to use flex_arrays on code intended for .36
http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commitdiff;h=6371dcd36f649d9d07823f31400618155a20dde1

> I'm hoping distros aren't creating internal dependencies on this interface 
> that could practically be removed from upstream at any time given its lack 
> of popularity.

I've got some more patches that I'm looking towards .37 which would use
the _ptr helpers I suggested:

http://marc.info/?l=selinux&m=128086475312322&w=2
http://marc.info/?l=selinux&m=128086558513723&w=2

