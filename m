Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab2EWDiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:38:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53747 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2EWDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:38:07 -0400
Date: Tue, 22 May 2012 20:38:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: ethan zhao <ethan.kernel@gmail.com>
cc: aarcange@redhat.com, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Huge memory takes too long time to initialize on 4TB ?
In-Reply-To: <CABawtvMgrsAQaQy7RO5XFbj7qu8+4WHqaZbbNQOeEwhMs58Oyw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205222035591.28165@chino.kir.corp.google.com>
References: <CABawtvMgrsAQaQy7RO5XFbj7qu8+4WHqaZbbNQOeEwhMs58Oyw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-62897370-1337744285=:28165"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-62897370-1337744285=:28165
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 23 May 2012, ethan zhao wrote:

> Hi, aarcange
> 
>    When I boot kernel 2.6.39-100.6.1.el6uek.x86_64(actually 3.0.26)on
> a 4TB memory machine, got following call trace,
> That shows huge memory take too long time to initialize ? any help ?,
> I compared the huge_memory.c code between 3.0.26 and the current
> 3.2.x, no change.
> 

This has nothing to do with mm/huge_memory.c, which is transparent 
hugepages code, it's the lengthy iteration done for a very large 
ZONE_NORMAL in setup_zone_migrate_reserve().  

This should be fixed by 938929f14cb5 ("mm: reduce the amount of work done 
when updating min_free_kbytes") and was merged in 3.3.  Let us know if 
there's still a problem after upgrading to either that or 3.4
--397155492-62897370-1337744285=:28165--
