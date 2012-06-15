Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2FOHtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:49:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:15451 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2FOHtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156678943"
Date: Fri, 15 Jun 2012 10:49:09 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 4/8] Added /proc/net/hci via bt_procfs_init()
Message-ID: <20120615074907.GA7205@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120615.021718.862586446299200414.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615.021718.862586446299200414.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Fri, Jun 15, 2012 at 02:17:18AM +0900, Masatake YAMATO wrote:
> Added /proc/net/hci via bt_procfs_init().
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  net/bluetooth/hci_sock.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index 5914623..3452d27 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1107,21 +1107,32 @@ int __init hci_sock_init(void)
>  		return err;
>  
>  	err = bt_sock_register(BTPROTO_HCI, &hci_sock_family_ops);
> -	if (err < 0)
> +	if (err < 0) {
> +	  	BT_ERR("HCI socket registration failed");
>  		goto error;
> +	}
> +
> +	err = bt_procfs_init(THIS_MODULE, &init_net, "hci", &hci_sk_list, NULL);
> +	if (err < 0) {
> +		BT_ERR("Failed to create HCI proc file");
> +		bt_sock_unregister(BTPROTO_HCI);
> +		goto error;
> +	}
> +
>  

too much spaces here?

Best regards 
Andrei Emeltchenko 

>  	BT_INFO("HCI socket layer initialized");
>  
>  	return 0;
>  
>  error:
> -	BT_ERR("HCI socket registration failed");

