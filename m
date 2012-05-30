Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2E3SWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:22:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49821 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab2E3SWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:22:41 -0400
Date: Wed, 30 May 2012 20:22:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mroos@linux.ee,
        JBottomley@parallels.com
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Message-ID: <20120530182239.GD15635@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	mroos@linux.ee, JBottomley@parallels.com
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:21:25AM -0700, Dan Williams wrote:
> Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
> introduces a boot regression by moving sd probe work off of the global
> async queue.  Using a local async domain hides the probe work from being
> synchronized by wait_for_device_probe()->async_synchronize_full().
> 
> Fix this by teaching async_synchronize_full() to flush all async work
> regardless of domain, and take the opportunity to convert scsi scanning
> to async_schedule().  This enables wait_for_device_probe() to flush scsi
> scanning work.

Looks like those fix a similar boot issue I reported earlier:

http://marc.info/?l=linux-kernel&m=133839683405526&w=2

Should I give them a run or are they still in review?

Thanks.

-- 
Regards/Gruss,
Boris.
