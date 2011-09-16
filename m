Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1IPNUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:20:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1IPNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:20:05 -0400
Date: Fri, 16 Sep 2011 09:19:30 -0400
From: Josef Bacik <josef@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve lseek scalability v3
Message-ID: <20110916131929.GA27738@dhcp231-156.rdu.redhat.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916130054.GA8997@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916130054.GA8997@parisc-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 07:00:55AM -0600, Matthew Wilcox wrote:
> On Thu, Sep 15, 2011 at 04:06:46PM -0700, Andi Kleen wrote:
> > Currently generic_file_llseek users synchronize all on the inode i_mutex,
> > which is very heavy handed because it affects even different processes.
> > 
> > This patchkit attempts to make generic_file_llseek (mostly) lockless.
> 
> Yes, but, are there any real workloads which care?  I know will-it-scale
> says that lseek doesn't scale, but any real app which has a seek-heavy
> workload is surely using pread()/pwrite() by now ... after all, they
> were in UNIX98 so they've been a standard for 13 years.
>

Apparently postgresql uses lseek heavily

http://rhaas.blogspot.com/2011/08/linux-and-glibc-scalability.html

Thanks,

Josef 
