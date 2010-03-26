Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0CZXxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:53:54 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:51398 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab0CZXxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <201003172118.41559.temerkhanov@cifronik.ru>
References: <201003172118.41559.temerkhanov@cifronik.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Mar 2010 17:53:32 -0600
X-Google-Sender-Auth: 869c554daf3e1ff3
Message-ID: <fa686aa41003261653j5a9be6e8gbe8f12e19a563cd6@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
To: Sergey Temerkhanov <temerkhanov@cifronik.ru>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not got time to review this patch right now, but Sergey and
Steven, you both posted MPMC drivers on the same day; Steven on the
microblaze list and Sergey on the powerpc list.  Can you two please
coordinate and figure out how to mork toward a single driver that will
meet both your needs?  I don't want to have 2 drivers (3 if you count
the ll_temac driver) in mainline for the same hardware interface.

Thanks,
g.

On Wed, Mar 17, 2010 at 12:18 PM, Sergey Temerkhanov
<temerkhanov@cifronik.ru> wrote:
> This patch adds generic support for Xilinx MPMC SoftDMA channels which are
> used by, e.g., LLTEMAC and other IP cores (including custom cores). So, the
> implemented functions include only SDMA channels enumeration and control
> (finding device by phandle property, channel reset, initialization of RX/TX
> links, enabling/disabling IRQs, šIRQ coalescing control and submission of
> descriptors (struct sdma_desc).
>
> The users of this subsystem are supposed to get the pointer to the struct
> sdma_device by phandle (using sdma_find_device() function), fill the struct
> sdma_client with pointers to the callback functions which are called on rx/tx
> completion, on error, and when sdma_reset is called by any client and then
> register the client with add_client() (sdma_del_client can be used to
> unregister the struct sdma_client)
>
> Also, some auxiliary functions are provided to check the status of descriptors
> (busy, done, start of packet, end of packet).
>
> The user is also responsible for maintenance of linked descriptors queue,
> proper initialization of their fields, and submission of the descriptors list
> to SDMA channel. IRQ acknowledge must be performed by user too (calling
> sdma_[rx|tx]_irq_ack respectively in [rx|tx]_complete callbacks). Also on RX
> side user must check the __be32 user[4] fields of descriptors to get the
> information supplied by SDMA channel.
>
> This code uses SDMA channels in "Tail pointer fashion", i.e. the call to
> sdma_[rx|tx]_init is performed only once after reset and then only sdma_[rx|
> tx]_submit calls are used to update the pointer to the last descriptor in SDMA
> channel.
>
> Simple bus driver for MPMC is also added by this patch.
>
> This code is in production use with our internal LLTEMAC driver implementation
> since 2008 and with a few custom cores drivers since 2009.
>
> This code currently supports only soft MPMCs, i.e., only SDMA channels with
> memory-mapped registers. In order to support channels with DCR, a few
> modifications are needed.
>
> Any comments and suggestions are appreciated.
>
> Regards, Sergey Temerkhanov, Cifronic ZAO
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
