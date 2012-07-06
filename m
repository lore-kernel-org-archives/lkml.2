Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab2GFVeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:34:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37964 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GFVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Jq0oaq0Scq46C=_6LNhMyBv76QxHQDpujsuq-bizytQ@mail.gmail.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
	<20120313081235.GC15333@redhat.com>
	<CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
	<CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
	<20120528140448.GA22783@redhat.com>
	<CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
	<20120529092154.GA2441@redhat.com>
	<CAErSpo6Xxq_kcEYACKUsuNDOJDhEDnxWgBUateOJEBcfqufhSg@mail.gmail.com>
	<CANHD2=o-eyd2JR7oK4gJgQi3Mi-a=R1RKuGsuWzzR_WosQaNEA@mail.gmail.com>
	<20120702053110.GA2500@redhat.com>
	<CANHD2=pEham5SZ6EguurMd9MBuyptyx5CGF1RDhU8Ow9CaRoXA@mail.gmail.com>
	<CAErSpo6Jq0oaq0Scq46C=_6LNhMyBv76QxHQDpujsuq-bizytQ@mail.gmail.com>
Date: Fri, 6 Jul 2012 14:34:42 -0700
X-Google-Sender-Auth: xeJvvAzfdUcF3Pzy9SQ-lGXGO30
Message-ID: <CAE9FiQXwx7L2H=BBcUbH2t3NyfAGZtrm4LG_uQ0OdoSTAZUgTw@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 1:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>  pci 0000:0b:00.0: reg 10: [mem 0xf1eff000-0xf1efffff]
> -pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 0b-0b]
> add_size 1000
> +pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus
> 0b-0b] add_size 200000
> +pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref]
> get_res_add_size add_size 200000
> +pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> +pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
>  pci_bus 0000:0b: resource 1 [mem 0xf1e00000-0xf1efffff]
> -pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
> +pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]

Those wild print out about add_size is used to double check if the
option size is passed correctly.

diff between 3.3 and 3.4:
in kernel 3.4, 1c.0 pref mem64 get allocated before 1c.1 pref mem64.
that should be caused by: We replaced local version resource list with
generic list.

But that should not be reason for why 3.3 does not work on Kamil's setup.

I would suspect that pci pm change fixes the problem.

Thanks

Yinghai
