Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1BXPRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:17:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39578 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1BXPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DkybzNTOxwZd5j4zolsFAMVyslV/lmTaS/0s/G0LyVefQGM+KwTtA0HBIeMmKSBma4
         X0ybQ0fD6eYpjv6ASSbq9uvsFEJ/zMQIWHVscFtfuWhmcWP0CXgObz0dzsdMbzm0MKV4
         9P6QpmGb0RLhtLQ2VBhvOSyaGHdqMcYJ1qGd0=
Date: Thu, 24 Feb 2011 16:17:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Dominik Klein <dk@in-telegence.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110224151701.GQ7840@htj.dyndns.org>
References: <4D6222A8.6090303@in-telegence.net>
 <20110221184442.GM6428@redhat.com>
 <4D63BA3B.7070809@in-telegence.net>
 <20110222152426.GD28269@redhat.com>
 <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D66720E.70102@in-telegence.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:58:22PM +0100, Dominik Klein wrote:
> Hi
> 
> > Hmmm...  Maybe the following commit?
> > 
> > commit 7576958a9d5a4a677ad7dd40901cdbb6c1110c98
> 
> Unfortunately not. This does not fix it for me.
> 
> Vivek introduced me to git bisect and I will try to do that tomorrow to
> find the changeset.

Maybe watching what the workqueue is doing using the following trace
events could be helpful.

# grep workqueue /sys/kernel/debug/tracing/available_events
workqueue:workqueue_insertion
workqueue:workqueue_execution
workqueue:workqueue_creation
workqueue:workqueue_destruction

Thanks.

-- 
tejun
