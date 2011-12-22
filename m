Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1LVM5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 07:57:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48395 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1LVM5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 07:57:41 -0500
MIME-Version: 1.0
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Date: Thu, 22 Dec 2011 12:57:40 +0000
Message-ID: <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 1:00 AM, Minchan Kim <minchan@kernel.org> wrote:
> This patch is follow-up of Christohp Hellwig's work
> [RFC: ->make_request support for virtio-blk].
> http://thread.gmane.org/gmane.linux.kernel/1199763
>
> Quote from hch
> "This patchset allows the virtio-blk driver to support much higher IOP
> rates which can be driven out of modern PCI-e flash devices.  At this
> point it really is just a RFC due to various issues."

Basic question to make sure I understood this series: does this patch
bypass the guest I/O scheduler (but then you added custom batching
code into virtio_blk.c)?

If you're stumped by the performance perhaps compare blktraces of the
request approach vs the bio approach.  We're probably performing I/O
more CPU-efficiently but the I/O pattern itself is worse.

Stefan
