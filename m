Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2FYRfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:35:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2FYRfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:35:41 -0400
Message-ID: <1340645735.18025.88.camel@twins>
Subject: Re: [PATCH 00/12] kmap_atomic cleanup for 3.6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        dhowells <dhowells@redhat.com>
Date: Mon, 25 Jun 2012 19:35:35 +0200
In-Reply-To: <201206251518.08791.arnd@arndb.de>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	 <201206232111.25411.arnd@arndb.de> <1340598382.19173.3.camel@cr0>
	 <201206251518.08791.arnd@arndb.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 15:18 +0000, Arnd Bergmann wrote:
> > Different arch has different values for KM_TYPE_NR, I am not sure if
> > unifying them to a fixed value could fit all? 

No you can't. Some arch's have arch specific KM_TYPE thingies, like FRV.

> > For safety, I kept their original values.
> 
> My fear is that it will make it harder to clean that code up for
> real, when there is no longer an indication about where the number
> comes from.

Agreed, I'd much prefer it if we'd come up with a sane way to compute
the max value before doing away with these enums.

Sadly I haven't been able to come up with a sane way short of whole
program analysis.
