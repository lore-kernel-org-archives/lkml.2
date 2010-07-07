Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0GGPXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:23:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:43872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0GGPXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:23:17 -0400
Date: Thu, 8 Jul 2010 01:23:03 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 04/11] vfs: Allow handle based open on symlinks
Message-ID: <20100707152303.GS11732@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:42:54PM +0530, Aneesh Kumar K.V wrote:
> The patch update may_open to allow handle based open on symlinks.
> The file handle based API use file descritor returned from open_by_handle_at
> to do different file system operations. To find the link target name we
> need to get a file descriptor on symlinks.

This is a pretty big change, isn't it? Have you looked through vfs to
ensure this is actually OK? I was just looking at remount,ro code, for
example, and it seems to assume only writable open files on ISREG
files.

Is this restricted to RDONLY? Really, it should be O_NONE...


