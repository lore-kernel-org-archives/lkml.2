Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1CYOpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:45:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1CYOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QbNTSPECLpxhx7wcwr66IhH00j2Ha2BrSS57sW03O1kPIzvTP59rqI/C3i34ZA7IDe
         8GH96oudO3Ku/Wpxfq6S9sm9s93o5TMh/Mzd+RBUxQpbOhifB2Hu0+Dk/j37Mc7bVBon
         /+7IUHaO0HW2uQ9EB3O0wWuWqy6yUv4e/eFZ8=
Date: Fri, 25 Mar 2011 15:45:44 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Theodore Tso <tytso@MIT.EDU>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
Subject: Re: linux-next: manual merge of the ext4 tree with Linus' tree
Message-ID: <20110325144544.GF1409@htj.dyndns.org>
References: <20110325125643.91510e0e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325125643.91510e0e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen, Ted.

On Fri, Mar 25, 2011 at 12:56:43PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the ext4 tree got a conflict in
> fs/ext4/super.c between commit fd89d5f2030a ("ext4: convert to
> alloc_workqueue()") from Linus' tree and commit 198868f35de9 ("ext4: Use
> single thread to perform DIO unwritten convertion") from the ext4 tree.
> 
> I just used the ext4 tree version.

Both are about the same conversion but the one using alloc_workqueue()
is better because 1. create_singlethread_workqueue() is going away and
2. it doesn't require strict ordering among queued works.

Ted, what do you think?

Thanks.

-- 
tejun
