Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2ABQWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:22:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2ABQWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:22:00 -0500
Message-ID: <4F01D997.1070501@redhat.com>
Date: Mon, 02 Jan 2012 18:21:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Stefan Hajnoczi <stefanha@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to
 BIO
References: <1324429254-28383-1-git-send-email-minchan@kernel.org> <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com> <20111222234135.GB7056@barrios-laptop.redhat.com> <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com> <20120102161803.GA32365@infradead.org>
In-Reply-To: <20120102161803.GA32365@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 06:18 PM, Christoph Hellwig wrote:
> On Sun, Jan 01, 2012 at 04:45:42PM +0000, Stefan Hajnoczi wrote:
> > win.  The fact that you added batching suggests there is some benefit
> > to what the request-based code path does.  So find out what's good
> > about the request-based code path and how to get the best of both
> > worlds.
>
> Batching pretty much always is a winner.  The maximum bio size is small
> enough that we'll frequently see multiple contiguos bios.  

Maybe the maximum bio size should be increased then; not that I disagree
with your conclusion.

> Because of
> that the Md layer fo example uses the same kind of batching.  I've tried
> to make this more general by passing a bio list to ->make_request and
> make the on-stack plugging work on bios, but in the timeslice I had
> available for that I didn't manage to actually make it work.
>
>

-- 
error compiling committee.c: too many arguments to function

