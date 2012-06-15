Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2FOHxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:53:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:53367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2FOHxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157938132"
Date: Fri, 15 Jun 2012 10:53:06 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 7/8] Added /proc/net/rfcomm via bt_procfs_init()
Message-ID: <20120615075305.GC7205@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120615.021835.1759601069982013045.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615.021835.1759601069982013045.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Fri, Jun 15, 2012 at 02:18:35AM +0900, Masatake YAMATO wrote:
> Added /proc/net/rfcomm via bt_procfs_init().
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  net/bluetooth/rfcomm/sock.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> index e8707de..0d0a35f 100644
> --- a/net/bluetooth/rfcomm/sock.c
> +++ b/net/bluetooth/rfcomm/sock.c
> @@ -1052,8 +1052,18 @@ int __init rfcomm_init_sockets(void)
>  		return err;
>  
>  	err = bt_sock_register(BTPROTO_RFCOMM, &rfcomm_sock_family_ops);
> -	if (err < 0)
> +	if (err < 0) {
> +	  	BT_ERR("RFCOMM socket layer registration failed");
>  		goto error;
> +	}
> +
> +	err = bt_procfs_init(THIS_MODULE, &init_net, "rfcomm", &rfcomm_sk_list, NULL);
> +	if (err < 0) {
> +		BT_ERR("Failed to create RFCOMM proc file");
> +		bt_sock_unregister(BTPROTO_RFCOMM);
> +		goto error;
> +	}
> +
>  

Extra space here.

Best regards 
Andrei Emeltchenko


