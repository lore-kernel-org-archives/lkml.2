Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1FQRmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:42:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1FQRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:42:43 -0400
Date: Fri, 17 Jun 2011 19:42:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] VFS: Do (nearly) lockless generic_file_llseek
Message-ID: <20110617174239.GG16236@one.firstfloor.org>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org> <201106171440.14224.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171440.14224.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 02:40:14PM +0200, Arnd Bergmann wrote:
> On Thursday 16 June 2011 23:07:18 Andi Kleen wrote:
> > So still need a lock, but can use a cheap local one.
> > 
> > This patch implements this new scheme in generic_file_llseek.
> > I dropped generic_file_llseek_unlocked and changed all callers.
> 
> What about default_llseek? If you change generic_file_llseek, you should
> probably change that, too.

That's used by a lot of drivers, and since I cannot audit them
all I chose to be conservative. not sure it's ever performance
critical anyways?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
