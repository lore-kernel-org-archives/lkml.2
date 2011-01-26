Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1AZJa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:30:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1AZJa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPagMniDvyvItoEX6yByKBLPShEzrCCiYYdGAfEvBGhCnYjeMCBLJ1hfNtCSjwQ4vl
         pk1hkG7FJ3SFARzrwNHUYLrKwqexK/Ef3Bkxc7Q0w1C2oZChxXIQjXEz2ISxWstNr0OY
         G8Yfc/LZkBYxX6kFjMPcwJvPJY0363C2I7YeA=
Date: Wed, 26 Jan 2011 10:30:51 +0100
From: Tejun Heo <tj@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: Re: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
 support flags
Message-ID: <20110126093051.GA12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126071626.GI27190@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126071626.GI27190@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:16:26PM -0800, Darrick J. Wong wrote:
> This patch is the first in a series to refactor the barrier= mount options out
> of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;
> of course, the automatic default is the safe choice, i.e. to leave them
> enabled.  Obviously, only a seasoned administrator should ever be overriding
> the defaults.

Hmmm... wouldn't it be better to just export flush and fua instead of
ignore_*?  So that the admin can turn things on and off as [s]he seems
fit?  Also, it might be better to export them in a single attribute,
say cache_control or something.  Only subset of the combinations make
sense anyway - none, flush, flush_fua.

Thanks.

-- 
tejun
