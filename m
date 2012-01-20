Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab2ATWMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:12:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2ATWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:12:34 -0500
Date: Fri, 20 Jan 2012 14:12:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation
 library
Message-Id: <20120120141232.a7572919.akpm@linux-foundation.org>
In-Reply-To: <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Jan 2012 16:51:56 -0600
Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> This patch creates a new memory allocation library named
> zsmalloc.

I haven't really begun to look at this yet.  The code is using many
fields of struct page in new ways.  This is key information for anyone
to effectively review the code.  So please carefully document (within
the code itself) the ways in which the various page fields are used:
semantic meaning of the overload, relationships between them, any
locking rules or assumptions.  Ditto any other data structures.  This
code should be reviewed very carefully by others so please implement it
with that intention.

It appears that a pile of dead code will be generated if CPU hotplug is
disabled.  (That's if it compiles at all!).  Please take a look at users
of hotcpu_notifier() - this facility cunningly causes all the hotplug code
to vanish from vmlinux if it is unneeded.


afacit this code should be added to core mm/.  Addition of code like
this to core mm/ will be fiercely resisted on principle!  Hence the
(currently missing) justifications for adding it had best be good ones.

