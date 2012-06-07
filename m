Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab2FGDK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 23:10:56 -0400
Received: from mail2.shareable.org ([80.68.89.115]:55731 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2FGDKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 23:10:53 -0400
X-Greylist: delayed 2440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 23:10:53 EDT
Date: Thu, 7 Jun 2012 03:29:31 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] make reading /proc/mounts consistent
Message-ID: <20120607022931.GB26406@jl-vm1.vm.bytemark.co.uk>
References: <1338362354-19519-1-git-send-email-vdavydov@parallels.com>
 <87aa0lf7w8.fsf@xmission.com>
 <77E04EBA-1AD8-4D9D-930B-575F29E3EDC1@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77E04EBA-1AD8-4D9D-930B-575F29E3EDC1@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir Davydov wrote:
> >> This is achieved by keeping the position where a process stopped as a
> >> pointer to mount entry and resuming reading from the position. If a mount entry
> >> is removed, all processes that stopped on the entry are advanced i.e.  their
> >> position is moved to the next entry. To achieve this, all processes reading
> >> /proc/mounts are organized in a linked list.
> >> 
> >> An example of /proc/mounts inconsistency is here:
> >> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593516
> > 
> > In the specific case of schroot I'm not convinced that you shouldn't
> > just increase the user space buffer size if you don't read everything.
> > Or to simply use mount namespaces to make unmounting unnecessary.
> 
> I agree, but there may be a lot of programs that already read
> /proc/mounts and don't care about its consistency.

I have cared about its consistency, but didn't realise it didn't
provide it.  Oops!  I will use a bigger buffer in future, thanks for
pointing it out ;-)

-- Jamie
