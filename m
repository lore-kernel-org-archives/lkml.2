Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0EONdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 09:33:54 -0400
Received: from www84.your-server.de ([213.133.104.84]:56640 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0EONdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 09:33:53 -0400
Subject: Re: [PATCH 4/4] add example files to the kernel sample directory
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, tytso@mit.edu, iws@ovro.caltech.edu
In-Reply-To: <20100514134609.54e05968.akpm@linux-foundation.org>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
	 <1273654167-31067-5-git-send-email-stefani@seibold.net>
	 <20100514134609.54e05968.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 15 May 2010 15:33:38 +0200
Message-ID: <1273930418.32082.12.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is the patch 0003-replace-the-old-non-generic-API.patch correct applied?

This patch renames the files created by patch 

0002-add-the-new-generic-kfifo-API.patch 

from 
kernel/kfifo-new.c into kernel/kfifo.c
and
include/linux/kfifo-new.h into include/linux/kfifo.h.

Both destination files still exists, so git must overwrite them. This
was done in request by Greg, not to break the kernel build at this point
in the patch sequence.

Stefani

Am Freitag, den 14.05.2010, 13:46 -0700 schrieb Andrew Morton:
> On Wed, 12 May 2010 10:49:27 +0200
> stefani@seibold.net wrote:
> 
> > This patch add four examples to the kernel sample directory.
> 
> x86_64 allmodconfig:
> 
> samples/kfifo/dma-example.c: In function 'example_init':
> samples/kfifo/dma-example.c:27: error: array type has incomplete element type
> samples/kfifo/dma-example.c:41: error: implicit declaration of function 'kfifo_put'
> samples/kfifo/dma-example.c:44: error: implicit declaration of function 'kfifo_get'
> samples/kfifo/dma-example.c:48: error: implicit declaration of function 'kfifo_dma_in_prepare'
> samples/kfifo/dma-example.c:48: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:48: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:48: error: negative width in bit-field '<anonymous>'
> samples/kfifo/dma-example.c:54: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:54: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:54: error: negative width in bit-field '<anonymous>'
> samples/kfifo/dma-example.c:60: error: implicit declaration of function 'sg_is_last'
> samples/kfifo/dma-example.c:71: error: implicit declaration of function 'kfifo_dma_in_finish'
> samples/kfifo/dma-example.c:74: error: implicit declaration of function 'kfifo_dma_out_prepare'
> samples/kfifo/dma-example.c:74: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:74: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:74: error: negative width in bit-field '<anonymous>'
> samples/kfifo/dma-example.c:80: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:80: warning: type defaults to 'int' in declaration of 'type name'
> samples/kfifo/dma-example.c:80: error: negative width in bit-field '<anonymous>'
> samples/kfifo/dma-example.c:97: error: implicit declaration of function 'kfifo_dma_out_finish'
> samples/kfifo/dma-example.c:27: warning: unused variable 'sg'
> make[2]: *** [samples/kfifo/dma-example.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> samples/kfifo/bytestream-example.c:44:52: error: macro "DECLARE_KFIFO" passed 3 arguments, but takes just 2
> samples/kfifo/bytestream-example.c:44: warning: type defaults to 'int' in declaration of 'DECLARE_KFIFO'
> samples/kfifo/bytestream-example.c: In function 'testfunc':
> samples/kfifo/bytestream-example.c:56: error: 'test' undeclared (first use in this function)
> samples/kfifo/bytestream-example.c:56: error: (Each undeclared identifier is reported only once
> samples/kfifo/bytestream-example.c:56: error: for each function it appears in.)
> samples/kfifo/bytestream-example.c:60: error: implicit declaration of function 'kfifo_put'
> samples/kfifo/bytestream-example.c:83: error: implicit declaration of function 'kfifo_get'
> samples/kfifo/bytestream-example.c: In function 'fifo_write':
> samples/kfifo/bytestream-example.c:99: error: 'test' undeclared (first use in this function)
> samples/kfifo/bytestream-example.c: In function 'fifo_read':
> samples/kfifo/bytestream-example.c:115: error: 'test' undeclared (first use in this function)
> samples/kfifo/bytestream-example.c: In function 'example_init':
> samples/kfifo/bytestream-example.c:139: error: 'test' undeclared (first use in this function)
> samples/kfifo/bytestream-example.c:139: error: 'testkfifo_buffer' undeclared (first use in this function)
> make[2]: *** [samples/kfifo/bytestream-example.o] Error 1
> samples/kfifo/record-example.c:53: error: syntax error before numeric constant
> samples/kfifo/record-example.c:53: warning: type defaults to 'int' in declaration of 'mytest'
> samples/kfifo/record-example.c:53: warning: data definition has no type or storage class
> samples/kfifo/record-example.c:55: error: syntax error before 'test'
> samples/kfifo/record-example.c:55: warning: type defaults to 'int' in declaration of 'test'
> samples/kfifo/record-example.c:55: warning: data definition has no type or storage class
> samples/kfifo/record-example.c: In function 'testfunc':
> samples/kfifo/record-example.c:67: warning: passing argument 1 of 'kfifo_in' from incompatible pointer type
> samples/kfifo/record-example.c:70: error: implicit declaration of function 'kfifo_peek_len'
> samples/kfifo/record-example.c:75: warning: passing argument 1 of 'kfifo_in' from incompatible pointer type
> samples/kfifo/record-example.c:78: warning: passing argument 1 of 'kfifo_len' from incompatible pointer type
> samples/kfifo/record-example.c:81: warning: passing argument 1 of 'kfifo_out_peek' from incompatible pointer type
> samples/kfifo/record-example.c:81: error: too few arguments to function 'kfifo_out_peek'
> samples/kfifo/record-example.c:86: warning: passing argument 1 of 'kfifo_is_empty' from incompatible pointer type
> samples/kfifo/record-example.c:87: warning: passing argument 1 of 'kfifo_out' from incompatible pointer type
> samples/kfifo/record-example.c: In function 'fifo_write':
> samples/kfifo/record-example.c:103: warning: passing argument 1 of 'kfifo_from_user' from incompatible pointer type
> samples/kfifo/record-example.c: In function 'fifo_read':
> samples/kfifo/record-example.c:119: warning: passing argument 1 of 'kfifo_to_user' from incompatible pointer type
> samples/kfifo/record-example.c: In function 'example_init':
> samples/kfifo/record-example.c:143: error: 'testkfifo_buffer' undeclared (first use in this function)
> samples/kfifo/record-example.c:143: error: (Each undeclared identifier is reported only once
> samples/kfifo/record-example.c:143: error: for each function it appears in.)
> samples/kfifo/record-example.c:143: error: incompatible types in assignment
> make[2]: *** [samples/kfifo/record-example.o] Error 1
> samples/kfifo/inttype-example.c:44:41: error: macro "DEFINE_KFIFO" passed 3 arguments, but takes just 2
> samples/kfifo/inttype-example.c:44: warning: type defaults to 'int' in declaration of 'DEFINE_KFIFO'
> samples/kfifo/inttype-example.c: In function 'testfunc':
> samples/kfifo/inttype-example.c:57: error: implicit declaration of function 'kfifo_put'
> samples/kfifo/inttype-example.c:57: error: 'test' undeclared (first use in this function)
> samples/kfifo/inttype-example.c:57: error: (Each undeclared identifier is reported only once
> samples/kfifo/inttype-example.c:57: error: for each function it appears in.)
> samples/kfifo/inttype-example.c:75: error: implicit declaration of function 'kfifo_peek'
> samples/kfifo/inttype-example.c:79: error: implicit declaration of function 'kfifo_get'
> samples/kfifo/inttype-example.c: In function 'fifo_write':
> samples/kfifo/inttype-example.c:95: error: 'test' undeclared (first use in this function)
> samples/kfifo/inttype-example.c: In function 'fifo_read':
> samples/kfifo/inttype-example.c:111: error: 'test' undeclared (first use in this function)
> 


