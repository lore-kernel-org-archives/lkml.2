Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab1FWNg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:36:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48503 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1FWNg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:36:27 -0400
Date: Thu, 23 Jun 2011 14:36:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110623133605.GA28333@srcf.ucam.org>
References: <20110622095341.GA3353@albatros>
 <20110622153742.GA18983@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622153742.GA18983@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 08:37:42AM -0700, Greg KH wrote:
> On Wed, Jun 22, 2011 at 01:53:41PM +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().
> > 
> > There are numerous printk() instances with user supplied input as "%s"
> > data, and unprivileged user may craft log messages with substrings
> > containing control characters via these printk()s.  Control characters
> > might fool root viewing the logs via tty.
> 
> There are "numerous" places this could happen?

USB product identifiers?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
