Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1EFTz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:55:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab1EFTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:55:54 -0400
Date: Fri, 6 May 2011 12:55:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] add hook to read_from_oldmem() to check for non-ram
 pages
Message-Id: <20110506125546.72d138ed.akpm@linux-foundation.org>
In-Reply-To: <20110506193916.GA26129@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
	<20110503190806.GA12485@aepfle.de>
	<20110505142551.b4d2d95a.akpm@linux-foundation.org>
	<20110506105545.GA16945@aepfle.de>
	<20110506123019.80461d5d.akpm@linux-foundation.org>
	<20110506193916.GA26129@aepfle.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 21:39:16 +0200
Olaf Hering <olaf@aepfle.de> wrote:

> On Fri, May 06, Andrew Morton wrote:
> 
> > So as your module will have a reference to vmcore.c's register and unregister
> > functions, nothing needs to be done: the presence of the client module alone
> > will pin the vmcore.c module.
> 
> I meant the other way around. Keep /proc/vmcore open and read from it,
> then try to rmmod foo.ko which provides fn().
> 

The client foo.ko will need to prevent itself from being unloaded while
it's actively doing stuff, yes.  Typically that would be done in its
module_exit() function - wait for current activity to complete and
block new activity.  The "block new activity" thing should be automatic
because nobody has any more references to anything in the module.

