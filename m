Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1ERQj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834Ab1ERQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:39:57 -0400
Date: Wed, 18 May 2011 09:39:51 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110518163951.GA24143@suse.de>
References: <20110518163142.GA3367@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518163142.GA3367@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:31:44PM +0400, Vasiliy Kulikov wrote:
> Currently there is no good way to effectively globally restrict an
> access to sysfs files.  It's possible only to chmod the sysfs'
> root/directories to fully deny access to sysfs (sub-)tree to some users
> or chmod files after they are created.  The latter approach is racy,
> however.

Why do you want to do this?  What is in sysfs files that is not
gloabally ok to access?  That should be fixed first, if at all, instead
of wanting to modify the whole sysfs tree, right?

> The patch introduces sysfs mount options parsing and adds 4 new options:
> uid, gid, mode and umask.  uid, gid, and umask are classical options,
> mode is a global restricting mode mask that defined the most relaxed
> possible file mode.  E.g. if mode=0750 then "chmod 0664" changes file's
> permissions to 0640.

What is going to break if you do this?  Have you tested it?  I'd be very
worried about this.

Again, what's the root problem you are trying to solve here?

thanks,

greg k-h
