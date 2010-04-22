Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0DVCwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 22:52:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32856 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab0DVCwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 22:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NF4Q2Oxgg72E7epZKBaIjY086ZNVwYoCfTtJi3R8/Vlk1pCXt+clkAnmUejaVm6fdU
         s0UVdDT+ce5qmYIifr/TdvBiwiAnhi1Abz+5JLgKCp0imnVKXsDcgZxZhUdcEbNAQVW6
         qeQcFAtH1djnJh0ZEGpW+08NiM5xdkaOWmAUw=
Date: Thu, 22 Apr 2010 04:52:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #15805] reiserfs locking
Message-ID: <20100422025224.GA12888@nowhere>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.wMG.FRSzLB@tosh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFfFNFyTSF.A.wMG.FRSzLB@tosh>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 05:19:25AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
> Subject		: reiserfs locking
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2010-04-15 21:02 (5 days old)
> Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2


That doesn't look like related to the bkl removal.

In fact what I wonder is how we missed that before.

vfs_readdir() take the directory inode mutex
    |
    ------- copy_to_user() takes the mm->mmap_sem

sys_unmap() takes mm->mmap_sem
    |
    ------- reiserfs_file_release() takes inode mutex


The lock inversion can not happen as sys_getdents() can't be called
after the directory is closed.

I'm not sure what to do. Adding more people in Cc.

