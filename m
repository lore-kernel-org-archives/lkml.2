Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1JXWzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1JXWzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:55:17 -0400
Date: Mon, 24 Oct 2011 18:54:59 -0400
From: Dave Jones <davej@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Message-ID: <20111024225459.GB25654@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <JBottomley@parallels.com>,
	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
 <1319496149.2094.3.camel@Joe-Laptop>
 <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wrote:
 
 > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
 > We could grep for "k[mzc]alloc(GFP_".

Make sure to ignore bio_kmalloc (which has reverse argument order to kmalloc, ugh)

	Dave
