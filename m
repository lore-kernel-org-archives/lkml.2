Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1AZRBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:01:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37101 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1AZRBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:01:41 -0500
Date: Wed, 26 Jan 2011 09:00:04 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: Re: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
	support flags
Message-ID: <20110126170004.GF32261@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110126071200.GE32261@tux1.beaverton.ibm.com> <20110126071626.GI27190@tux1.beaverton.ibm.com> <20110126093051.GA12520@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126093051.GA12520@htj.dyndns.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:30:51AM +0100, Tejun Heo wrote:
> On Tue, Jan 25, 2011 at 11:16:26PM -0800, Darrick J. Wong wrote:
> > This patch is the first in a series to refactor the barrier= mount options out
> > of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;
> > of course, the automatic default is the safe choice, i.e. to leave them
> > enabled.  Obviously, only a seasoned administrator should ever be overriding
> > the defaults.
> 
> Hmmm... wouldn't it be better to just export flush and fua instead of
> ignore_*?  So that the admin can turn things on and off as [s]he seems

I considered having a general knob to override the automatic FLUSH/FUA
detection, but I thought that it wasn't a good idea to provide a mechanism to
enable features that devices don't advertise.  Mostly I was imagining horror
scenarios like USB storage devices that claim no write cache and but then catch
on fire if someone sends flush anyway.  Not using advertised features seemed
less risky.

> fit?  Also, it might be better to export them in a single attribute,
> say cache_control or something.  Only subset of the combinations make
> sense anyway - none, flush, flush_fua.

I agree.  It could be simplified even further to a simple boolean that means
"use neither" or "use whatever's supported".

--D
