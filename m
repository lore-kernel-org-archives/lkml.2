Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1FQVTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 17:19:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab1FQVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 17:19:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] VFS: Do (nearly) lockless generic_file_llseek
Date: Fri, 17 Jun 2011 23:18:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org> <201106171440.14224.arnd@arndb.de> <20110617174239.GG16236@one.firstfloor.org>
In-Reply-To: <20110617174239.GG16236@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106172318.38338.arnd@arndb.de>
X-Provags-ID: V02:K0:Fl3WpBBQHCJ7svVkp3XmjA/jWlb9juMZejYNpOvQ+Ta
 aDF5t+s+lqTO33TJlFtRbsnqCUDKDEhdQ21lG/BafHDJM/NS1x
 ptkae/7pLVToaioY2nqQGStlyPlS8lOfBFRl4M1A/JtbFSD1tN
 WKLLqefHUpgcmKf1gmKRhLW1fGYF7nMsGq2b3wjTcXGZ6Kp0GC
 F83xbkKgqsTGJ5lAwN98A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 19:42:39 Andi Kleen wrote:
> On Fri, Jun 17, 2011 at 02:40:14PM +0200, Arnd Bergmann wrote:
> > On Thursday 16 June 2011 23:07:18 Andi Kleen wrote:
> > > So still need a lock, but can use a cheap local one.
> > > 
> > > This patch implements this new scheme in generic_file_llseek.
> > > I dropped generic_file_llseek_unlocked and changed all callers.
> > 
> > What about default_llseek? If you change generic_file_llseek, you should
> > probably change that, too.
> 
> That's used by a lot of drivers, and since I cannot audit them
> all I chose to be conservative. not sure it's ever performance
> critical anyways?

Probably not. Note that all uses of default_llseek were introduced
in the conversion from an implicit default_llseek when they did not
set the operation before the BKL conversion. There were also patches
floating around to merge generic_file_llseek and default_llseek.

There was not a single case of a driver that relied on the BKL to
lock against default_llseek before I changed it to i_mutex.

	Arnd
