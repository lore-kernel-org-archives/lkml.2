Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2DCM3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:29:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57750 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2DCM3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:29:53 -0400
Date: Tue, 3 Apr 2012 09:29:46 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
Message-ID: <20120403122946.GA25048@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@intel.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
 <20120329022839.GA26111@joana>
 <86r4wct9q7.fsf@sumi.keithp.com>
 <20120330065456.GA9173@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330065456.GA9173@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

* Gustavo Padovan <gustavo@padovan.org> [2012-03-30 03:54:56 -0300]:

> Hi Keith,
> 
> * Keith Packard <keithp@keithp.com> [2012-03-28 19:35:44 -0700]:
> 
> > <#part sign=pgpmime>
> > On Wed, 28 Mar 2012 23:28:39 -0300, Gustavo Padovan <gustavo@padovan.org> wrote:
> > 
> > > A consequence is that you'll need to use newer version of bluez, at least 4.99.
> > > Or call the bluetooth daemon (from a pre 4.99 version) with a parameter to
> > > disable the new interface:
> > 
> > That's not OK -- you're breaking user space with this kernel change. I
> > know I get bashed every time I suggest that we 'fix' the kernel and
> > require new user space X bits...
> 
> Can you try the following patch? It should fix the compatibility problem you had.

Did you had chance to test this patch?

	Gustavo

> 
> commit d21c1177b9cf067809ccee2746633cfea3a8b062
> Author: Gustavo Padovan <gustavo@padovan.org>
> Date:   Thu Mar 29 09:47:53 2012 -0300
> 
>     Bluetooth: Fix userspace compatibility issue with mgmt interface
>     
>     To ensure that old user space versions do not accidentally pick up and
>     try to use the management channel, use a different channel number.
>     
>     Reported-by: Keith Packard <keithp@keithp.com>
>     Acked-by: Johan Hedberg <johan.hedberg@intel.com>
>     Acked-by: Marcel Holtmann <marcel@holtmann.org>
>     Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 344b0f9..ba7f148 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -1327,8 +1327,8 @@ struct sockaddr_hci {
>  #define HCI_DEV_NONE   0xffff
>  
>  #define HCI_CHANNEL_RAW                0
> -#define HCI_CHANNEL_CONTROL    1
>  #define HCI_CHANNEL_MONITOR    2
> +#define HCI_CHANNEL_CONTROL    3
>  
>  struct hci_filter {
>         unsigned long type_mask;
