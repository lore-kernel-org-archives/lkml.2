Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1AERqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1AERqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:46:03 -0500
Date: Wed, 5 Jan 2011 09:46:01 -0800
From: Chris Wright <chrisw@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH] PCI: sysfs: Update ROM to include default owner write
 access
Message-ID: <20110105174601.GB4529@x200.localdomain>
References: <20110105172615.20107.20267.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105172615.20107.20267.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> The PCI sysfs ROM interface requires an enabling write to access
> the ROM image, but the default file mode is 0400.  The original
> proposed patch adding sysfs ROM support was a true read-only
> interface, with the enabling bit coming in as a feature request.
> I suspect it was simply an oversight that the file mode didn't
> get updated to match the API.

This is often not an issue given normal root capabilities, but once
we strip those capabilities, the default 0400 causes O_RDWR to fail.
As Alex said, given the only way to use the file is to write to it first,
making it writable makes sense.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Acked-by: Chris Wright <chrisw@redhat.com>
