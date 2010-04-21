Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0DUQFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:05:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab0DUQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:05:12 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 18:05:11 +0200
Message-ID: <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, Corrado,

Here's a graph showing the number of issued but not yet completed
requests versus time for CFQ and NOOP schedulers running the tiobench
benchmark with 8 threads:

http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/queue-depth.jpg

It shows pretty clearly the performance problem is because CFQ is not
issuing enough request to fill the bandwidth.

Is this the correct behavior of CFQ or is this a bug?

This is on a vanilla 2.6.34-rc4 kernel with two tunables modified:

read_ahead_kb=512
low_latency=0 (for CFQ)

Thanks,
Miklos


