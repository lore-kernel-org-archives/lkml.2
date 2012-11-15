Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993287Ab2KOKwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:52:23 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56327
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992442Ab2KOKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:52:21 -0500
Date: Thu, 15 Nov 2012 05:52:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] target/sbc: Make WRITE_SAME check differentiate
 between UNMAP=[1,0]
Message-ID: <20121115105220.GB28956@infradead.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-2-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352405238-23267-2-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (flags[0] & 0x08)
> +		cmd->se_cmd_flags |= SCF_WRITE_SAME_DISCARD;

I don't like this flag at all.  We can still simply check the CDB
during ->execute_cmd and avoid this redundant flag.

Except for that bit the changes look fine, but should not be a patch
on their own.  Without an actual implementation this relaxation is
actively harmful.
