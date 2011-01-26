Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1AZHMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:12:21 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38428 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1AZHMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:12:20 -0500
Date: Tue, 25 Jan 2011 23:12:00 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
        adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com
Subject: [PATCHSET] Refactor barrier=/nobarrier flags from fs to block layer
Message-ID: <20110126071200.GE32261@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>From what I can tell, most of the filesystems that know how to issue commands
to flush the write cache also have some mechanism for the user to override
whether or not the filesystem actually issues those flushes.  Unfortunately,
the term "barrier" is obsolete having been changed into flushes in 2.6.36, and
many of the filesystems implement the mount options with slightly different
syntaxes (barrier=[0|1|none|flush], nobarrier, etc).

This patchset adds to the block layer a sysfs knob that an administrator can
use to disable flushes, and removes the mount options from the filesystem code.
As a starting point, I'm removing the mount options and flush toggle from
jbd2/ext4.

Anyway, I'm looking for some feedback about refactoring the barrier/flush
control knob into the block layer.  It sounds like we want a knob that picks
the safest option (issue flushes when supported) unless the administrator
decides that it is appropriate to do otherwise.  I suspect that there are good
arguments for not having a knob at all, and good arguments for a safe knob.
However, since I don't see the barrier options being removed en masse, I'm
assuming that we still want a knob somewhere.  Do we need the ignore_fua knob
too?  Is this the proper way to deprecate mount options out of filesystems?

--D
