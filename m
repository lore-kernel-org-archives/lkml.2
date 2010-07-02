Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0GBVrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:47:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41812 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0GBVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=E5VJzpONYTdODrW3pqTCvuKs16ZTWuI9M9MglhYnye8y3p8f/fjyNLk8BzQTdyG+6n
         QizUxYbNj0ZO0zYNkCpsu6WAvI3XZA/gwH0eEXjRZB/bZDnzOf2yHTDXoxSU324q7mIl
         +qVorAfNiU0XUrTONjBM1b/pRTY7xKvn7dzH0=
MIME-Version: 1.0
In-Reply-To: <20100702072826.GB16856@schottelius.org>
References: <20100702072826.GB16856@schottelius.org>
Date: Fri, 2 Jul 2010 14:47:26 -0700
X-Google-Sender-Auth: 38hakKFo2aM9O0s3kTCkMnQ5WIk
Message-ID: <AANLkTikO8yXXBC9Wt4LKZeu1JD5TKMOW5reB3jpk8Ahp@mail.gmail.com>
Subject: Re: e1000e: receives no packets after resume (2.6.35-rc3-00262-g984bc96)
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Nico Schottelius <nico-linux-20100702@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>, e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 00:28, Nico Schottelius
<nico-linux-20100702@schottelius.org> wrote:
> Good morning hackers,
>
> I've seen that in kernels before, but now suffering from it:
> e1000e does not receive any packets after third resume:
>
> --------------------------------------------------------------------------------
> [8:16] kr:clyde# dhcpcd eth0
> dhcpcd[11589]: version 5.2.5 starting
> dhcpcd[11589]: eth0: rebinding lease of 129.132.102.115
> dhcpcd[11589]: eth0: broadcasting for a lease
> ^Cdhcpcd[11589]: received SIGINT, stopping
> dhcpcd[11589]: eth0: removing interface
> [8:16] kr:clyde# dhcpcd eth0
> dhcpcd[11601]: version 5.2.5 starting
> dhcpcd[11601]: eth0: rebinding lease of 129.132.102.115
> dhcpcd[11601]: eth0: broadcasting for a lease
> ^Cdhcpcd[11601]: received SIGINT, stopping
> dhcpcd[11601]: eth0: removing interface
> [8:16] kr:clyde# dhcpcd eth0
> dhcpcd[11784]: version 5.2.5 starting
> dhcpcd[11784]: eth0: rebinding lease of 129.132.102.115
> ^Cdhcpcd[11784]: received SIGINT, stopping
> dhcpcd[11784]: eth0: removing interface
> [8:16] kr:clyde# dhcpcd eth0
> dhcpcd[11830]: version 5.2.5 starting
> dhcpcd[11830]: eth0: rebinding lease of 129.132.102.115
> dhcpcd[11830]: eth0: broadcasting for a lease
> dhcpcd[11830]: timed out
> [8:17] kr:clyde# rmmod e1000e
> [8:18] kr:clyde# modprobe e1000e
> [8:18] kr:clyde# dhcpcd eth0
> dhcpcd[11855]: version 5.2.5 starting
> dhcpcd[11855]: eth0: waiting for carrier
> ^Cdhcpcd[11855]: received SIGINT, stopping
> dhcpcd[11855]: eth0: removing interface
> [8:18] kr:clyde# dhcpcd eth0
> dhcpcd[11871]: version 5.2.5 starting
> dhcpcd[11871]: eth0: rebinding lease of 129.132.102.115
> dhcpcd[11871]: eth0: acknowledged 129.132.102.115 from 129.132.57.97
> dhcpcd[11871]: eth0: checking for 129.132.102.115
> dhcpcd[11871]: eth0: leased 129.132.102.115 for 86400 seconds
> dhcpcd[11871]: forked to background, child pid 11892
> [8:18] kr:clyde#
> --------------------------------------------------------------------------------
>
> Are you aware of this issues?
>
> Cheers,
>
> Nico
>
> --

Adding the Networking Kernel mailing list (netdev) and Intel Linux LAN
Driver mailing list (e1000-patches)...

Would it be possible to get more information about the system/setup?

For example, can you provide the following information:
     - full lspci output (lspci -vvv)
     - ethtool -i ethX
     - dmesg  - after loading the driver and configuring the interfaces
     - kernel config

-- 
Cheers,
Jeff
