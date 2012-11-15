Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768787Ab2KOTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:23:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53391 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768590Ab2KOTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:23:22 -0500
Subject: Re: [PATCH 2/3] target: Add max_write_same_len device attribute
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20121115105312.GC28956@infradead.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
	 <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>
	 <20121115105312.GC28956@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Nov 2012 11:23:12 -0800
Message-ID: <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 05:53 -0500, Christoph Hellwig wrote:
> On Thu, Nov 08, 2012 at 08:07:17PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a new max_write_same_len device attribute for use with
> > WRITE_SAME w/ UNMAP=0 backend emulation.
> > 
> > Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
> > set the default MAXIMUM WRITE SAME LENGTH value of zero.
> 
> why do we need an exposed attribute for this?
> 

This is useful for userspace to reduce the allowed maximum from the
default 0xFFFF set by IBLOCK.  Allowing huge WRITE_SAMEs can very much
effect performance (esp. with spinning media), so being able to reduce
the max we accept via a userspace tunable is helpful.

--nab

