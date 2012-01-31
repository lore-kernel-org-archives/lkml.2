Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2AaJ1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:27:52 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53052
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab2AaJ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:27:49 -0500
Date: Tue, 31 Jan 2012 04:27:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: XFS problem
Message-ID: <20120131092748.GA22999@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
 <20120124213936.GA1505@infradead.org>
 <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
 <20120127105859.GC23335@infradead.org>
 <CAAA8XhOoF_AN_-1PsYQ+hp7adc08YuYqvA_3Bv9nqtuOzO1kOg@mail.gmail.com>
 <20120127191532.GA25529@infradead.org>
 <CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
 <CAAA8XhPTnj+d1CzmpDvrYLRuZ3=p6A0sN1z-=yswezxA+MkF+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAA8XhPTnj+d1CzmpDvrYLRuZ3=p6A0sN1z-=yswezxA+MkF+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 06:34:52PM -0200, Kelbel Junior wrote:
> How you prefer to pre allocate space?
> xfs I/O or by 'dd' to do it?
>
> What other information you would like to better understand and manage
> to solve this problem?

Do you expect to fill most of the file with data?  In that case
preallocating the file before starting I/O is the best way to do it.

>From the shell you can do it using the xfs_io 'resvsp' command, and
from C code using the fallocate system call, or if it's not present
the xfs RESVSP ioctl, as documented by the xfsctl manpage when
you have the xfsprogs development libraries installed.

If you actually want to keep the file sparse it's much harder.  You
could try larger I/O sized, or trying using the xfs extent size hint
which is set using the XFS_IOC_FSSETXATTR ioctl, again documented in
the xfsctl man page.

