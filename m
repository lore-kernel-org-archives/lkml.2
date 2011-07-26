Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1GZIof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:44:35 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:44478 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1GZIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:44:28 -0400
Subject: Re: [PATCH-v2 1/2] kernel.h: Add DIV_ROUND_UP_ULL and
	DIV_ROUND_UP_SECTOR_T macro usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1311665743-20639-1-git-send-email-nab@linux-iscsi.org>
References: <1311665743-20639-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain
Date: Tue, 26 Jul 2011 01:35:06 -0700
Message-Id: <1311669306.17766.256.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 07:35 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add new DIV_ROUND_UP_SECTOR_T macro usage for 32-bit architectures requiring
> a new DIV_ROUND_UP_ULL, and existing 64-bit usage with DIV_ROUND_UP.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  include/linux/kernel.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 953352a..e81b647 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -56,6 +56,14 @@
>  
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> +#define DIV_ROUND_UP_ULL(ll,d) \
> +	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> +
> +#if BITS_PER_LONG == 32
> +# define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP_ULL(ll, d)
> +#else
> +# define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP(ll,d)
> +#endif
>  

Hi Andrew,

Is CONFIG_LBDAF=n usage going to have problems with the above..?  

Things are looking as expected AFAICT with some quick tests with
CONFIG_LBDAF=y on i386, but still need to verify the CONFIG_LBDAF=n on
32-bit as well.  Any more comments here are appercitated.

Thank you,

--nab



