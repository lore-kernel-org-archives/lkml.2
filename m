Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2LST6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:58:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2LST6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:58:08 -0500
Date: Wed, 19 Dec 2012 14:58:01 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
Message-ID: <20121219195801.GA14456@redhat.com>
References: <50CB8C74.3090102@canonical.com>
 <yq11uesdzya.fsf@sermon.lab.mkp.net>
 <50D0C971.1000907@canonical.com>
 <yq1bodq7zdv.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1bodq7zdv.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19 2012 at 11:58am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:
> 
> Joseph> I captured the netconsole output from boot until I reproduced
> Joseph> the bug. The RIP points to kcryptd_crypt_write_io_submit() in
> Joseph> ~/drivers/md/dm-crypt.c.  The output can be seen at:
> 
> I'm thinking that dm-crypt should probably set max_write_same_sectors to
> 0. It doesn't really make much sense for a crypto driver to pass that
> command through.
> 
> Mike, do you want to look into this?

Milan (cc'd) is more well-versed with dm-crypt.  Though we likely need
to audit DM relative to WRITE SAME too (will do once I understand what
added safety/constraints are needed).

But do we know mount to somwhow be issuing WRITE SAME requests?  Martin,
why is it you weren't able to reproduce (I haven't attempted yet)?
