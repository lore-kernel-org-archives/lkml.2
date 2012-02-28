Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464Ab2B1POi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:14:38 -0500
Received: from lulu.zabbo.net ([69.168.54.52]:33872 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996Ab2B1POg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:14:36 -0500
Message-ID: <4F4CEF5A.1020207@zabbo.net>
Date: Tue, 28 Feb 2012 10:14:34 -0500
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <20120228092926.GA2766@infradead.org>
In-Reply-To: <20120228092926.GA2766@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For one you make ->aio_read/write trivial wrappers around ->read_iter
> and ->write_iter.  Instead of keeping this duplication around please
> make sure to entirely kill ->aio_read/write and always use your new
> methods.  Without that we'll get into a complete mess like the old
> ->aio_read/write vs ->readv/writev again.
>
> A similar thing applies to the ->direct_IO/direct_IO_bvec interface -

Yeah, that's reasonable.  Perhaps obviously, we started with new entry
points to minimize the amount of churn we'd have to go through to test
the change in behaviour.

It's going to be messy to try and abstract away the pinning and dirtying
of the iter regions from direct IO through the iter interface, but maybe
not horribly so.

- z
