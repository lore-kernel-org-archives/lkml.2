Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2JJOpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:45:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab2JJOpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:45:34 -0400
Subject: Re: [PATCH] extcon : callback function to read cable property
From: anish kumar <anish198519851985@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Oct 2012 23:45:28 +0900
Message-ID: <1349880328.22926.2.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 15:53 +0530, Jenny TC wrote:
> For some cables a boolean variable will not be enough to represent
> the state and properties of the cable. For example a charger cable can
> have states CONNECT,DISCOONECT,SUSPEND(Host suspend for SDP cable),
> RESUME(Host wakeup), and UPDATE (to increase the charge
> current after USB enumaeration).Also the properties of the cable may
> vary based on the state. FOr example in SUSPENDED state platforms can
> support 0/100/500/950(USB 3.0) mA based on the HW. To initiate charging
> the consumer should be able to get the charger properties dynamically.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  include/linux/extcon.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index 073fd49..2e61ee0 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -122,6 +122,7 @@ struct extcon_dev {
>  	/* --- Optional callbacks to override class functions --- */
>  	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
>  	ssize_t	(*print_state)(struct extcon_dev *edev, char *buf);
> +	int (*get_cable_properties)(const char *cable_name, void *cable_props);
>  
>  	/* --- Internal data. Please do not set. --- */
>  	struct device	*dev;
> @@ -177,6 +178,19 @@ struct extcon_specific_cable_nb {
>  	unsigned long previous_value;
>  };
>  
> +enum extcon_chrgr_cbl_stat {
> +	EXTCON_CHRGR_CABLE_CONNECTED,
> +	EXTCON_CHRGR_CABLE_DISCONNECTED,
> +	EXTCON_CHRGR_CABLE_SUSPENDED,
> +	EXTCON_CHRGR_CABLE_RESUMED,
> +	EXTCON_CHRGR_CABLE_UPDATED,
> +};
I think the reason why we have extcon is in first place
is to only notify the clients of cable connection and
disconnection and it is up to the client to decide what
else to do with the cable such as finding which state it
is in and other details.
So I feel this should not be handled in the extcon.

However it is up to the maintainer to decide.
> +
> +struct extcon_chrgr_cbl_props {
> +	enum extcon_chrgr_cbl_stat cable_stat;
> +	unsigned long mA;
> +};
> +
>  #if IS_ENABLED(CONFIG_EXTCON)
>  
>  /*


