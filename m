Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2AWS5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:57:41 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48249 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2AWS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:57:40 -0500
Message-ID: <4F1DADA0.4030300@vflare.org>
Date: Mon, 23 Jan 2012 13:57:36 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <20120120141232.a7572919.akpm@linux-foundation.org>
In-Reply-To: <20120120141232.a7572919.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 05:12 PM, Andrew Morton wrote:

> On Mon,  9 Jan 2012 16:51:56 -0600
> Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> 
>> This patch creates a new memory allocation library named
>> zsmalloc.
> 
> I haven't really begun to look at this yet.  The code is using many
> fields of struct page in new ways.  This is key information for anyone
> to effectively review the code.  So please carefully document (within
> the code itself) the ways in which the various page fields are used:
> semantic meaning of the overload, relationships between them, any
> locking rules or assumptions.  Ditto any other data structures.  This
> code should be reviewed very carefully by others so please implement it
> with that intention.
> 


> It appears that a pile of dead code will be generated if CPU hotplug is
> disabled.  (That's if it compiles at all!).  Please take a look at users
> of hotcpu_notifier() - this facility cunningly causes all the hotplug code
> to vanish from vmlinux if it is unneeded.
> 
>


ok, will look into these issues and add necessary documentation.

 
> afacit this code should be added to core mm/.  Addition of code like
> this to core mm/ will be fiercely resisted on principle!  Hence the
> (currently missing) justifications for adding it had best be good ones.
> 


I don't think this code should ever get into mm/ since its just a driver
specific allocator. However its used by more than one driver (zcache and
zram) so it may be moved to lib/ or drivers/zsmalloc atmost?

Thanks,
Nitin
