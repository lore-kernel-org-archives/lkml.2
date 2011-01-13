Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab1AMUiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:38:21 -0500
Received: from thunk.org ([69.25.196.29]:52601 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1AMUiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:38:14 -0500
Date: Thu, 13 Jan 2011 15:38:09 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power plug off / on - EXT4-fs (sda1): re-mounted. Opts:
 errors=remount-ro,commit=600
Message-ID: <20110113203809.GB31800@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Jason Wessel <jason.wessel@windriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
 <B48664E0-16B7-49A5-AE50-1C3DA751DC2C@mit.edu>
 <4D2F5EFE.6060407@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F5EFE.6060407@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:22:22PM -0600, Jason Wessel wrote:
> 
> That is interesting indeed.  While I am running a substantially
> older kernel ( 2.6.35-24-generic #42-Ubuntu 10.10 ).  I was seeing a
> consistent problem where if you pulled the power cord while the
> system was under heavy I/O load, you could no longer run sync.  The
> jbd2 process just kept on running forever continuously.  Shutdown
> was impossible to because vfs unmount blocked (hold power key for 4+
> seconds...).

Yeah, there were two separate bugs that have been addressed recently;
both were in the generic VFS and writeback code.  One was a fix to do
more efficient forced writeouts at umount time.

The other was a fix so that if new dirty pages are continuously being
created (by having processes always writing more pages, those dastards :-),
to make sync stop by only having it write the pages that were dirty
at the time when the sync was initiated.

					- Ted
