Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0JTU0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:26:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab0JTU0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:26:48 -0400
Message-ID: <4CBF5067.20109@oracle.com>
Date: Wed, 20 Oct 2010 13:26:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Fix kfifo_alloc() to return a signed int value
References: <1287605544-21270-1-git-send-email-stefani@seibold.net> <1287605544-21270-2-git-send-email-stefani@seibold.net>
In-Reply-To: <1287605544-21270-2-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/10 13:12, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This patch adds a new __kfifo_int_must_check_helper() helper function,
> which is needed for kfifo_alloc() to return the right signed integer
> value.
> 
> The origin __kfifo_must_check_helper() helper was renamed into
> __kfifo_uint_must_check_helper() to show the sign which is expected and
> returned.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  include/linux/kfifo.h |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index 62dbee5..10308c6 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -172,7 +172,13 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
>  
>  
>  static inline unsigned int __must_check
> -__kfifo_must_check_helper(unsigned int val)
> +__kfifo_uint_must_check_helper(unsigned int val)
> +{
> +	return val;
> +}
> +
> +static inline int __must_check
> +__kfifo_int_must_check_helper(int val)
>  {
>  	return val;
>  }
> @@ -267,7 +273,7 @@ __kfifo_must_check_helper(unsigned int val)
>   * @fifo: address of the fifo to be used
>   */
>  #define	kfifo_avail(fifo) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmpq = (fifo); \
>  	const size_t __recsize = sizeof(*__tmpq->rectype); \
> @@ -300,7 +306,7 @@ __kfifo_must_check_helper( \
>   * This function returns the size of the next fifo record in number of bytes.
>   */
>  #define kfifo_peek_len(fifo) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	const size_t __recsize = sizeof(*__tmp->rectype); \
> @@ -323,7 +329,7 @@ __kfifo_must_check_helper( \
>   * Return 0 if no error, otherwise an error code.
>   */
>  #define kfifo_alloc(fifo, size, gfp_mask) \
> -__kfifo_must_check_helper( \
> +__kfifo_int_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> @@ -419,7 +425,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_get(fifo, val) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	typeof((val) + 1) __val = (val); \
> @@ -460,7 +466,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_peek(fifo, val) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	typeof((val) + 1) __val = (val); \
> @@ -552,7 +558,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_out(fifo, buf, n) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	typeof((buf) + 1) __buf = (buf); \
> @@ -580,7 +586,7 @@ __kfifo_must_check_helper( \
>   * copied.
>   */
>  #define	kfifo_out_spinlocked(fifo, buf, n, lock) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	unsigned long __flags; \
>  	unsigned int __ret; \
> @@ -609,7 +615,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_from_user(fifo, from, len, copied) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	const void __user *__from = (from); \
> @@ -637,7 +643,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_to_user(fifo, to, len, copied) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	void __user *__to = (to); \
> @@ -764,7 +770,7 @@ __kfifo_must_check_helper( \
>   * writer, you don't need extra locking to use these macro.
>   */
>  #define	kfifo_out_peek(fifo, buf, n) \
> -__kfifo_must_check_helper( \
> +__kfifo_uint_must_check_helper( \
>  ({ \
>  	typeof((fifo) + 1) __tmp = (fifo); \
>  	typeof((buf) + 1) __buf = (buf); \


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
