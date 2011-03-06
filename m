Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab1CFPGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 10:06:20 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:46841 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1CFPGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 10:06:19 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Date: Sun, 6 Mar 2011 16:06:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <1299410212-24897-1-git-send-email-florian@mickler.org> <201103061306.10045.oliver@neukum.org> <20110306153805.001011a9@schatten.dmk.lab>
In-Reply-To: <20110306153805.001011a9@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103061606.38846.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 6. März 2011, 15:38:05 schrieb Florian Mickler:
> On Sun, 6 Mar 2011 13:06:09 +0100
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Sonntag, 6. März 2011, 12:16:52 schrieb Florian Mickler:

> > > Please take a look at it, as I do not do that much kernel hacking
> > > and don't wanna brake anybodys computer... :)
> > > 
> > > From my point of view this should _not_ go to stable even though it would
> > > be applicable. But if someone feels strongly about that and can
> > > take responsibility for that change...
> > 
> > The patch looks good and is needed in stable.
> > It could be improved by using a buffer allocated once in the places
> > you hold a mutex anyway.
> > 
> > 	Regards
> > 		Oliver
> 
> Ok, I now put a buffer member in the priv dib0700_state which gets
> allocated on the heap. 

This however is wrong. Just like DMA on the stack this breaks
coherency rules. You may do DMA to the heap in the sense that
you can do DMA to buffers allocated on the heap, but you cannot
do DMA to a part of another structure allocated on the heap.
You need a separate kmalloc for each buffer.
You can reuse the buffer with proper locking, but you must allocate
it seperately once.

	Regards
		Oliver
