Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1BAWID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:08:03 -0500
Received: from verein.lst.de ([213.95.11.210]:58027 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1BAWIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:08:01 -0500
Date: Tue, 1 Feb 2011 23:07:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/4] Fix error handling in hfsplus mount failure paths
Message-ID: <20110201220745.GA23889@lst.de>
References: <20110201162802.2dd07201@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201162802.2dd07201@katamari>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 04:28:02PM -0500, Chuck Ebbert wrote:
> hfsplus can generate NULL pointer exceptions when a user attempts
> to mount an invalid filesystem. In some paths it also leaks memory.
> 
> This series attempts to fix some of the most obvious problems.

Not in a very nice way, though.  The real problem here is that we

 a) can still return a failure after sb->s_root is set
 b) abuse hfsplus_put_super for error handling, which is totally
    ill-suited.

Take a look at the patch in
https://bugzilla.kernel.org/show_bug.cgi?id=27932 for a proper fix.
