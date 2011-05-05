Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1EEOLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:11:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:52425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab1EEOLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:11:43 -0400
Date: Thu, 5 May 2011 07:10:24 -0700
From: Greg KH <gregkh@suse.de>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] C2port:Fix deprecated exported interfaces c2port.h
Message-ID: <20110505141024.GA6461@suse.de>
References: <1304598549-3561-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304598549-3561-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 08:29:09PM +0800, Wanlong Gao wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Change to_class_dev to to_device since the struct class_device had
> merged to struct device.
> Fix the to_c2port_device interface since the struct c2port_device
> has no member named class.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  include/linux/c2port.h |    4 ++--

I don't know why you sent this to me, have you looked at the
scripts/get_maintainer.pl tool?


>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/c2port.h b/include/linux/c2port.h
> index 2a5cd86..7e6bd33 100644
> --- a/include/linux/c2port.h
> +++ b/include/linux/c2port.h
> @@ -60,8 +60,8 @@ struct c2port_ops {
>   * Exported functions
>   */
>  
> -#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
> -#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
> +#define to_device(obj) container_of(obj, struct device, kobj)
> +#define to_c2port_device(obj) container_of(obj, struct c2port_device, dev.kobj)

Doesn't this break the build?  If not, something is really wrong here.

confused,

greg k-h
