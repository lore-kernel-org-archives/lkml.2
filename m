Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0LHQQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0LHQQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:16:30 -0500
Date: Wed, 8 Dec 2010 11:15:56 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: ir-lirc-codec: fix integer overflow
Message-ID: <20101208161556.GB6586@redhat.com>
References: <20101202045126.GA1784@bicker>
 <20101204210522.GA5244@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101204210522.GA5244@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 12:05:22AM +0300, Vasiliy Kulikov wrote:
> 'n' may be bigger than MAX_INT*sizeof(int), if so checking of truncated
> (int)(n/sizeof(int)) for LIRCBUF_SIZE overflows and then using nontruncated 'count'
> doesn't make sense.  This is not a security issue as too big 'n' is catched in
> kmalloc() in memdup_user() call.  However, it's better to prevent WARN() in kmalloc().
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Now that I have my head out of my arse wrt the actual issue here, the
redundancy issue from v1 is resolved, and I've managed a full night's
sleep... ;)

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

