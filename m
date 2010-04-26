Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0DZUGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:06:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39164 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0DZUGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a7SHIQn5aFN76DF+EZ0CpAFScSJtIgoWQtTHSg4MoC940eaHNjGdEEa5IvgFJI7pNk
         NbMhzcxibqku3QT3TT63HWw4IBMd266KAT43LIplPFSc6SHkVD4/CE1pA+6ZbS9pURrw
         LbFeB5PDgaZQj/3l9D1+Ytjq3bTtRMhlGDR2E=
MIME-Version: 1.0
In-Reply-To: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
Date: Mon, 26 Apr 2010 15:06:29 -0500
Message-ID: <o2j2acbd3e41004261306n4da142bfp4e9a46561dbc8c46@mail.gmail.com>
Subject: Re: [RFC][PATCH v4 01/18] Add a new struct for device to manipulate 
	external buffer.
From: Andy Fleming <afleming@gmail.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 4:19 AM,  <xiaohui.xin@intel.com> wrote:
> From: Xin Xiaohui <xiaohui.xin@intel.com>
>
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81@gmail.com>
> Reviewed-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  include/linux/netdevice.h |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index c79a88b..bf79756 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -530,6 +530,22 @@ struct netdev_queue {
>        unsigned long           tx_dropped;
>  } ____cacheline_aligned_in_smp;
>
> +/* Add a structure in structure net_device, the new field is
> + * named as mp_port. It's for mediate passthru (zero-copy).
> + * It contains the capability for the net device driver,
> + * a socket, and an external buffer creator, external means
> + * skb buffer belongs to the device may not be allocated from
> + * kernel space.
> + */
> +struct mpassthru_port  {
> +       int             hdr_len;
> +       int             data_len;
> +       int             npages;
> +       unsigned        flags;
> +       struct socket   *sock;
> +       struct skb_external_page *(*ctor)(struct mpassthru_port *,
> +                               struct sk_buff *, int);
> +};


I tried searching around, but couldn't find where struct
skb_external_page is declared.  Where is it?

Andy
