Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2JCLr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:47:27 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41709
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab2JCLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:47:26 -0400
Date: Wed, 3 Oct 2012 07:47:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1
 operation
Message-ID: <20121003114721.GA16209@infradead.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
 <1348984696-30992-2-git-send-email-nab@linux-iscsi.org>
 <20121001084605.GA23497@infradead.org>
 <1349209004.28145.61.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349209004.28145.61.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:16:44PM -0700, Nicholas A. Bellinger wrote:
>          * Optionally allow fd_buffered_io=1 to be enabled for people
>          * who want use the fs buffer cache as an WriteCache mechanism.
>          *
>          * This means that in event of a hard failure, there is a risk
>          * of silent data-loss if the SCSI client has *not* performed a
>          * forced unit access (FUA) write, or issued SYNCHRONIZE_CACHE
>          * to write-out the entire device cache.
>          */

Oh, I get Vlads flame.  This doesn't simply disable O_DSYNC now but also
sets WCE=1.  In this case I don't really get the point of the patch, why
can't we simply set it from configfs?

