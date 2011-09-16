Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1IPNA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:00:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60692 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1IPNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:00:56 -0400
Date: Fri, 16 Sep 2011 07:00:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Improve lseek scalability v3
Message-ID: <20110916130054.GA8997@parisc-linux.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 04:06:46PM -0700, Andi Kleen wrote:
> Currently generic_file_llseek users synchronize all on the inode i_mutex,
> which is very heavy handed because it affects even different processes.
> 
> This patchkit attempts to make generic_file_llseek (mostly) lockless.

Yes, but, are there any real workloads which care?  I know will-it-scale
says that lseek doesn't scale, but any real app which has a seek-heavy
workload is surely using pread()/pwrite() by now ... after all, they
were in UNIX98 so they've been a standard for 13 years.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
