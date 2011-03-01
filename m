Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1CANoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 08:44:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51025 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1CANoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 08:44:37 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/9p: call vmtruncate before setattr 9p opeation
In-Reply-To: <20110301121012.GA15516@infradead.org>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1298969484-16199-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20110301121012.GA15516@infradead.org>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 01 Mar 2011 19:14:16 +0530
Message-ID: <87pqqbdkgf.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 07:10:12 -0500, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Mar 01, 2011 at 02:21:20PM +0530, Aneesh Kumar K.V wrote:
> > We need to call vmtruncate before 9p setattr operation, otherwise we
> > could write back some dirty pages between setattr with ATTR_SIZE and vmtruncate
> > causing some truncated pages to be written back to server
> 
> Please read the documentation.  vmtruncate is deprecated and no new
> users may be added at this point.
> 

I actually didn't add a new user for vmtruncate. But i did missed the
fact that vmtruncate is deprecated. I will do a new patch to switch to
truncate_setsize.

-aneesh
