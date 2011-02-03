Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1BCJb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:31:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41047 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1BCJbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:31:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cP6AX32qFGwpX5LU/Uz9j8tIv7Z5WPfnDNqhci01denfvYWyc1EKe1MSO1I1CaYjkQ
         P+9C2pPAhlim8A//8sxV530M1upa/JigY9zSlWiM4tTKUhiZCMKxgvEK330Xngr1nLmu
         zt8zcJzlXzAqbZsKyDX193PuW8fi2blUD0MUw=
Date: Thu, 3 Feb 2011 10:31:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to
 alloc_workqueue()
Message-ID: <20110203093120.GC2570@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-17-git-send-email-tj@kernel.org>
 <4D489B09.9010906@cs.wisc.edu>
 <20110202102521.GA24115@htj.dyndns.org>
 <4D49C172.3040600@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D49C172.3040600@cs.wisc.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Wed, Feb 02, 2011 at 02:41:22PM -0600, Mike Christie wrote:
> On 02/02/2011 04:25 AM, Tejun Heo wrote:
> >usually necessary.  The queue of pending works tend to be short and
> >consumed pretty fast.
> 
> What if we want to do something that could take a while, like doing
> recovery of a device/transport (so you have to send resets and
> logouts/logins and wait for the results but they could take a while
> if they timeout), should we be using something other than a
> workqueue so it does not interfere with other users?

As long as you don't use ordered workqueue, it wouldn't be a problem.
The max concurrency is determined by @max_active parameter to
alloc_workqueue() and workqueue will try to provide concurrency upto
the limit on demand as long as resources are available.

Thanks.

-- 
tejun
