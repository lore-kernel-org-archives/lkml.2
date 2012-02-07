Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2BGPXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:23:22 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2BGPXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:23:21 -0500
Message-ID: <4F3141E4.8080902@codemonkey.ws>
Date: Tue, 07 Feb 2012 09:23:16 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        kvm-ppc <kvm-ppc@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>	<51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>	<4F3117E5.6000105@redhat.com>	<EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>	<4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
In-Reply-To: <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 07:40 AM, Alexander Graf wrote:
>
> Why? For the HPET timer register for example, we could have a simple MMIO hook that says
>
>    on_read:
>      return read_current_time() - shared_page.offset;
>    on_write:
>      handle_in_user_space();
>
> For IDE, it would be as simple as
>
>    register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>    for (i = 1; i<  7; i++) {
>      register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>      register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>    }

You can't easily serialize updates to that address with the kernel since two 
threads are likely going to be accessing it at the same time.  That either means 
an expensive sync operation or a reliance on atomic instructions.

But not all architectures offer non-word sized atomic instructions so it gets 
fairly nasty in practice.

Regards,

Anthony Liguori
