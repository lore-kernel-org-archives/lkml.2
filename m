Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2FUTof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:44:35 -0400
Received: from www84.your-server.de ([213.133.104.84]:52646 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab2FUToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:44:34 -0400
Message-ID: <1340307897.23870.0.camel@wall-e>
Subject: Re: [PATCH] Grammatical cleanup of <linux/kfifo.h>, comments only
From: Stefani Seibold <stefani@seibold.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jun 2012 21:44:57 +0200
In-Reply-To: <alpine.DEB.2.02.1206210553410.18276@oneiric>
References: <alpine.DEB.2.02.1206210553410.18276@oneiric>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 21.06.2012, 05:55 -0400 schrieb Robert P. J. Day:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 

Acked by: Stefani Seibold <stefani@seibold.net>

> ---
> 
>   since i was perusing kfifo.h, i figured i might as well tidy it up
> while i was there.  yes, there are probably other possible tweaks, but
> this should catch most of it.
> 
>   again, there are all *comment* changes and should make no functional
> difference.
> 
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index 10308c6..9fa0050 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -23,30 +23,30 @@
>  #define _LINUX_KFIFO_H
> 
>  /*
> - * How to porting drivers to the new generic FIFO API:
> + * How to port drivers to the new generic FIFO API:
>   *
> - * - Modify the declaration of the "struct kfifo *" object into a
> + * - Modify the declaration of the "struct kfifo *" object into an
>   *   in-place "struct kfifo" object
>   * - Init the in-place object with kfifo_alloc() or kfifo_init()
>   *   Note: The address of the in-place "struct kfifo" object must be
> - *   passed as the first argument to this functions
> - * - Replace the use of __kfifo_put into kfifo_in and __kfifo_get
> - *   into kfifo_out
> - * - Replace the use of kfifo_put into kfifo_in_spinlocked and kfifo_get
> - *   into kfifo_out_spinlocked
> + *   passed as the first argument to these functions
> + * - Replace the use of __kfifo_put with kfifo_in and __kfifo_get
> + *   with kfifo_out
> + * - Replace the use of kfifo_put with kfifo_in_spinlocked and kfifo_get
> + *   with kfifo_out_spinlocked
>   *   Note: the spinlock pointer formerly passed to kfifo_init/kfifo_alloc
> - *   must be passed now to the kfifo_in_spinlocked and kfifo_out_spinlocked
> + *   must be passed now to kfifo_in_spinlocked and kfifo_out_spinlocked
>   *   as the last parameter
> - * - The formerly __kfifo_* functions are renamed into kfifo_*
> + * - The formerly __kfifo_* functions are renamed as kfifo_*
>   */
> 
>  /*
> - * Note about locking : There is no locking required until only * one reader
> - * and one writer is using the fifo and no kfifo_reset() will be * called
> - *  kfifo_reset_out() can be safely used, until it will be only called
> + * Note about locking : There is no locking required until only one reader
> + * and one writer is using the fifo and no kfifo_reset() will be called
> + * kfifo_reset_out() can be safely used, until it will be only called
>   * in the reader thread.
> - *  For multiple writer and one reader there is only a need to lock the writer.
> - * And vice versa for only one writer and multiple reader there is only a need
> + * For multiple writer and one reader there is only a need to lock the writer.
> + * And vice versa for only one writer and multiple readers there is only a need
>   * to lock the reader.
>   */
> 
> @@ -91,7 +91,7 @@ struct __kfifo {
>  	struct __STRUCT_KFIFO_PTR(type, 0, type)
> 
>  /*
> - * define compatibility "struct kfifo" for dynamic allocated fifos
> + * define compatibility "struct kfifo" for dynamically allocated fifos
>   */
>  struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0, void);
> 
> @@ -108,7 +108,7 @@ struct kfifo_rec_ptr_1 __STRUCT_KFIFO_PTR(unsigned char, 1, void);
>  struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
> 
>  /*
> - * helper macro to distinguish between real in place fifo where the fifo
> + * helper macro to distinguish between real in-place fifo where the fifo
>   * array is a part of the structure and the fifo type where the array is
>   * outside of the fifo structure.
>   */
> @@ -215,7 +215,7 @@ __kfifo_int_must_check_helper(int val)
>   * @fifo: address of the fifo to be used
>   *
>   * Note: usage of kfifo_reset() is dangerous. It should be only called when the
> - * fifo is exclusived locked or when it is secured that no other thread is
> + * fifo is exclusively locked or when it is secured that no other thread is
>   * accessing the fifo.
>   */
>  #define kfifo_reset(fifo) \
> @@ -325,7 +325,7 @@ __kfifo_uint_must_check_helper( \
>   * This macro dynamically allocates a new fifo buffer.
>   *
>   * The numer of elements will be rounded-up to a power of 2.
> - * The fifo will be release with kfifo_free().
> + * The fifo will be released with kfifo_free().
>   * Return 0 if no error, otherwise an error code.
>   */
>  #define kfifo_alloc(fifo, size, gfp_mask) \
> @@ -355,11 +355,11 @@ __kfifo_int_must_check_helper( \
>   * kfifo_init - initialize a fifo using a preallocated buffer
>   * @fifo: the fifo to assign the buffer
>   * @buffer: the preallocated buffer to be used
> - * @size: the size of the internal buffer, this have to be a power of 2
> + * @size: the size of the internal buffer, this must be a power of 2
>   *
> - * This macro initialize a fifo using a preallocated buffer.
> + * This macro initializes a fifo using a preallocated buffer.
>   *
> - * The numer of elements will be rounded-up to a power of 2.
> + * The number of elements will be rounded-up to a power of 2.
>   * Return 0 if no error, otherwise an error code.
>   */
>  #define kfifo_init(fifo, buffer, size) \
> @@ -378,10 +378,10 @@ __kfifo_int_must_check_helper( \
>   *
>   * This macro copies the given value into the fifo.
>   * It returns 0 if the fifo was full. Otherwise it returns the number
> - * processed elements.
> + * of processed elements.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_put(fifo, val) \
>  ({ \
> @@ -419,10 +419,10 @@ __kfifo_int_must_check_helper( \
>   *
>   * This macro reads the data from the fifo.
>   * It returns 0 if the fifo was empty. Otherwise it returns the number
> - * processed elements.
> + * of processed elements.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_get(fifo, val) \
>  __kfifo_uint_must_check_helper( \
> @@ -460,10 +460,10 @@ __kfifo_uint_must_check_helper( \
>   *
>   * This reads the data from the fifo without removing it from the fifo.
>   * It returns 0 if the fifo was empty. Otherwise it returns the number
> - * processed elements.
> + * of processed elements.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_peek(fifo, val) \
>  __kfifo_uint_must_check_helper( \
> @@ -503,7 +503,7 @@ __kfifo_uint_must_check_helper( \
>   * number of copied elements.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_in(fifo, buf, n) \
>  ({ \
> @@ -551,11 +551,11 @@ __kfifo_uint_must_check_helper( \
>   * @buf: pointer to the storage buffer
>   * @n: max. number of elements to get
>   *
> - * This macro get some data from the fifo and return the numbers of elements
> + * This macro gets some data from the fifo and returns the numbers of elements
>   * copied.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_out(fifo, buf, n) \
>  __kfifo_uint_must_check_helper( \
> @@ -582,7 +582,7 @@ __kfifo_uint_must_check_helper( \
>   * @n: max. number of elements to get
>   * @lock: pointer to the spinlock to use for locking
>   *
> - * This macro get the data from the fifo and return the numbers of elements
> + * This macro gets the data from the fifo and returns the numbers of elements
>   * copied.
>   */
>  #define	kfifo_out_spinlocked(fifo, buf, n, lock) \
> @@ -612,7 +612,7 @@ __kfifo_uint_must_check_helper( \
>   * fifo, depending of the available space and returns -EFAULT/0.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_from_user(fifo, from, len, copied) \
>  __kfifo_uint_must_check_helper( \
> @@ -640,7 +640,7 @@ __kfifo_uint_must_check_helper( \
>   * @to buffer and returns -EFAULT/0.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_to_user(fifo, to, len, copied) \
>  __kfifo_uint_must_check_helper( \
> @@ -668,7 +668,7 @@ __kfifo_uint_must_check_helper( \
>   * It returns the number entries in the scatterlist array.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macros.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_dma_in_prepare(fifo, sgl, nents, len) \
>  ({ \
> @@ -688,11 +688,11 @@ __kfifo_uint_must_check_helper( \
>   * @fifo: address of the fifo to be used
>   * @len: number of bytes to received
>   *
> - * This macro finish a DMA IN operation. The in counter will be updated by
> + * This macro finishes a DMA IN operation. The in counter will be updated by
>   * the len parameter. No error checking will be done.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macros.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define kfifo_dma_in_finish(fifo, len) \
>  (void)({ \
> @@ -713,13 +713,13 @@ __kfifo_uint_must_check_helper( \
>   * @nents: number of entries in the scatterlist array
>   * @len: number of elements to transfer
>   *
> - * This macro fills a scatterlist for DMA output which at most @len bytes
> + * This macro fills a scatterlist for DMA output with at most @len bytes
>   * to transfer.
> - * It returns the number entries in the scatterlist array.
> + * It returns the number of entries in the scatterlist array.
>   * A zero means there is no space available and the scatterlist is not filled.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macros.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_dma_out_prepare(fifo, sgl, nents, len) \
>  ({ \
> @@ -739,11 +739,11 @@ __kfifo_uint_must_check_helper( \
>   * @fifo: address of the fifo to be used
>   * @len: number of bytes transferd
>   *
> - * This macro finish a DMA OUT operation. The out counter will be updated by
> + * This macro finishes a DMA OUT operation. The out counter will be updated by
>   * the len parameter. No error checking will be done.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macros.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define kfifo_dma_out_finish(fifo, len) \
>  (void)({ \
> @@ -763,11 +763,11 @@ __kfifo_uint_must_check_helper( \
>   * @buf: pointer to the storage buffer
>   * @n: max. number of elements to get
>   *
> - * This macro get the data from the fifo and return the numbers of elements
> + * This macro gets the data from the fifo and returns the numbers of elements
>   * copied. The data is not removed from the fifo.
>   *
>   * Note that with only one concurrent reader and one concurrent
> - * writer, you don't need extra locking to use these macro.
> + * writer, you don't need extra locking to use this macro.
>   */
>  #define	kfifo_out_peek(fifo, buf, n) \
>  __kfifo_uint_must_check_helper( \
> 


