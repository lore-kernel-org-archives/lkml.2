Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1BNPqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:46:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57710 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1BNPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pe+8lzty0a3axzlQypoSgtAsmdCdY9eW7cMqPyocbNTv4TonQZbuEojedX+0Chkblc
         P7fwJJ0edHF5d7tT9Dde20IEOv4lhQy1U16Wpv3ieNtKMpxyY4BDNQUqwAmotbu7jCAA
         2bQ3SllD8CXudthJnSz3nhz9HdsXLodpmUpTs=
Date: Mon, 14 Feb 2011 16:46:01 +0100
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm fix for 2.6.38
Message-ID: <20110214154601.GS18742@htj.dyndns.org>
References: <20110211233844.GC30276@redhat.com>
 <1297525475.2584.1.camel@dolmen>
 <20110212155100.GR3770@htj.dyndns.org>
 <20110214153844.GA6909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214153844.GA6909@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 10:38:44AM -0500, David Teigland wrote:
> find_lkb seems to be getting an actual, but wrong lkid, so it's returning
> the wrong lkb in the receive routines.  It happens fairly quickly with
> multiple wq threads, but not at all with single.  One suspect I'm going to
> look at are the ls_stub and fields in the lockspace struct.  I'm not
> convinced extra send/recv threads give us that much benefit in practice,
> so it's not my top priority at the moment.

Hmmm... okay.  At any rate, please use alloc[_ordered]_workqueue()
interface.  create[_singlethread]_workqueue() will be deprecated soon.

Thanks.

-- 
tejun
