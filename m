Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1BOMqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:46:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab1BOMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:46:43 -0500
Date: Tue, 15 Feb 2011 12:46:29 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Message-ID: <20110215124629.GF5825@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D5A6EF4.3030905@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 01:17:56PM +0100, Milan Broz wrote:
>         fd = open(device, O_RDWR | flags);
>         if (fd == -1 && errno == EROFS) {
>                 *readonly = 1;
>                 fd = open(device, O_RDONLY | flags);
>         }

Would it be reasonable for your patch to return EROFS rather than
EACCES?

man 2 open:
       int open(const char *pathname, int flags, mode_t mode);

       EROFS  pathname  refers  to a file on a read-only file system and write
              access was requested.

       EACCES The requested access to the file is not allowed, or search  per‐
              mission  is denied for one of the directories in the path prefix
              of pathname, or the file did not exist yet and write  access  to
              the  parent  directory  is  not allowed.  (See also path_resolu‐
              tion(7).)

Alasdair

