Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0DFRJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:09:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0DFRJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:09:11 -0400
Date: Wed, 7 Apr 2010 03:09:03 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, corbet@lwn.net, linux-kernel@vger.kernel.org,
       linux-cachefs@redhat.com
Subject: Re: An incorrect assumption over radix_tree_tag_get()
Message-ID: <20100406170903.GH5288@laptop>
References: <23428.1270570789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23428.1270570789@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 05:19:49PM +0100, David Howells wrote:
> 
> Hi,
> 
> I think I've made a bad assumption over my usage of radix_tree_tag_get() in
> fs/fscache/page.c.
> 
> I've assumed that radix_tree_tag_get() is protected from radix_tree_tag_set()
> and radix_tree_tag_clear() by the RCU read lock.  However, now I'm not so
> sure.  I think it's only protected against removal of part of the tree.
> 
> Can you confirm?

It is safe. Synchronization requirements for using the radix tree API
are documented.
