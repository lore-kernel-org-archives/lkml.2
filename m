Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2ALQOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:14:19 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45005
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540Ab2ALQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:14:17 -0500
Date: Thu, 12 Jan 2012 11:14:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH] xfs: show uuid when mount fails due to duplicate uuid
Message-ID: <20120112161410.GA3810@infradead.org>
References: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:47:20AM +0900, Mitsuo Hayasaka wrote:
> When a system tries to mount a filesystem (FS) using UUID, the xfs
> returns -EINVAL and shows a message if a FS with the same UUID has
> been already mounted. It is useful to output the duplicate UUID
> with it.

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> -	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
> +	xfs_warn(mp,
> +		"Filesystem has duplicate UUID - can't mount: uuid = %pU",
> +		uuid);

Maybe we could write this a bit nicer as:

	xfs_warn(mp, "Filesystem has duplicate UUID %p - can't mount", uuid);

