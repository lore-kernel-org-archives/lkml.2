Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1FCDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 23:09:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42950 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1FCDJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 23:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to:x-pgp-key
         :user-agent;
        b=tyyMEVQEJ21PA7WeNOGcIW4gPXszE6ji9TIUtn/oRaMC5JhBxZXeUfwVufQIN4CiIa
         BpYVtDBR0pklrybotQm2MPMN3xMpRhW65bukoAKPiNjIZXY14pJF2x++btVxMFLXhg0N
         GGKd2k7JkCVcv2BSehkDoAQ62AiR8kuRRoHNU=
Date: Fri, 3 Jun 2011 00:08:43 -0300
From: Rafael Aquini <aquini@linux.com>
To: Russ Anderson <rja@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, rja@americas.sgi.com
Subject: Re: [PATCH] [BUGFIX] mm: hugepages can cause negative commitlimit
Message-ID: <20110603030841.GB10530@optiplex.tchesoft.com>
Reply-To: aquini@linux.com
References: <20110518153445.GA18127@sgi.com>
 <BANLkTinbHnrf2isuLzUFZN8ypaT476G1zw@mail.gmail.com>
 <20110519045630.GA22533@sgi.com>
 <BANLkTinyYP-je9Nf8X-xWEdpgvn8a631Mw@mail.gmail.com>
 <20110519221101.GC19648@sgi.com>
 <20110520130411.d1e0baef.akpm@linux-foundation.org>
 <20110520223032.GA15192@x61.tchesoft.com>
 <20110526210751.GA14819@optiplex.tchesoft.com>
 <20110602040821.GA7934@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602040821.GA7934@sgi.com>
X-PGP-Key: http://aquini.fedorapeople.org/AQUINI-GPG-KEY
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy Russ,

On Wed, Jun 01, 2011 at 11:08:31PM -0500, Russ Anderson wrote:
> 
> Yes, it fixes the inconsistency in reporting totalram_pages.
Thanks alot for the feedback.

> There seems to be another issue.  1G hugepages can be allocated at boot time, but
> cannot be allocated at run time.  "default_hugepagesz=1G hugepagesz=1G hugepages=1" on 
> the boot line works.  With "default_hugepagesz=1G hugepagesz=1G" the command
> "echo 1 > /proc/sys/vm/nr_hugepages" fails.
> 
> uv4-sys:~ # echo 1 > /proc/sys/vm/nr_hugepages
> -bash: echo: write error: Invalid argument

That's not an issue, actually. It seems to be , unfortunately, 
an implementation characteristic, due to an imposed arch constraint.
Further reference: http://lwn.net/Articles/273661/

Cheers!
-- 
Rafael Aquini <aquini@linux.com>
