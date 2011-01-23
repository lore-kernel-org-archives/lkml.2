Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1AWK31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 05:29:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1AWK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 05:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ua2ECvDOQQ7CpEUbYIKUt680CXCag8uugGe+9ldgwtpPX4qOcIHi1M/wiVTAbaB2T0
         FzU3p48UT+h9PP4JbGDOxK84ma9i294KbzRrZ3FjzIxfh2FhHrev7hWqendzU+voohHm
         FuwAx7M1RpDWQq5zeoeggnz8enIYQUKv1jvmc=
Date: Sun, 23 Jan 2011 11:29:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
        neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Message-ID: <20110123102920.GB23121@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110121185617.GI12072@redhat.com>
 <20110123102526.GA23121@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123102526.GA23121@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 11:25:26AM +0100, Tejun Heo wrote:
> Again, issuing flushes as fast as possible isn't necessarily better.
> It might feel counter-intuitive but it generally makes sense to delay
> flush if there are a lot of concurrent flush activities going on.
> Another related interesting point is that with flush merging,
> depending on workload, there's a likelihood that FUA, even if the
> device supports it, might result in worse performance than merged DATA
> + single POSTFLUSH sequence.

Let me add a bit.

In general, I'm a bit skeptical about the usefulness of hardware FUA
on a rotating disk.  All it saves is a single command issue overhead.
On storage array or SSDs, the balance might be different tho.  Event
hen, with flush merging, I think it would heavily depend on the
workload which way it would turn out.

Thanks.

-- 
tejun
