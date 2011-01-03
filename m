Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1ACO1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:27:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46187 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab1ACO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:27:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QHtA4HSeEXexnYv460bTlSi9GkLBrvDW2+mlwNc/dD9O4hu+1HP/WzuRgovHzOE/IA
         hnBCkeE3igqL2afIGVqBnWkRCfVzXZ+kCsWPxY+GolRM9mCYKML5YKfq2HsehKUMYNch
         QmtaHwDk7nLV+9O8UtwShJTQBXi+6Zh/GstFs=
Date: Mon, 3 Jan 2011 15:27:34 +0100
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 24/32] dlm: dlm workqueues aren't used in memory
 reclaim path
Message-ID: <20110103142734.GR18831@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-25-git-send-email-tj@kernel.org>
 <1294063107.2429.34.camel@dolmen>
 <20110103140107.GP18831@htj.dyndns.org>
 <1294064489.2429.58.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294064489.2429.58.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

On Mon, Jan 03, 2011 at 02:21:29PM +0000, Steven Whitehouse wrote:
> > Ooh, I see.  Hmmm... maybe I've asked this before but do you really
> > need WQ_MEM_RECLAIM there?  Is dlm used during memory reclaim?
> 
> Yes, it is in case of deallocation of inodes, so we have to be careful
> about that,

I see.  I'm still slightly unsure about the WQ_MEM_RECLAIM rules when
it comes to distributed file systems and stuff related to them, but I
think it basically comes down to whether the code can be in the swap
path or not.  e.g. for nfs backed write shared mapped files, nfs
definitely can be used during memory reclaim _but_ it's not guaranteed
to make forward progress under memory pressure and thus can't be
depended upon and shouldn't be used for swap.  IOW, it may free memory
but it's not in the critical path which should guarantee forward
progress.  Isn't dlm the same case?

Thank you.

-- 
tejun
