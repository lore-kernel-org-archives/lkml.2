Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab2BONd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:33:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab2BONd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:33:27 -0500
Message-ID: <4F3BB41E.60405@redhat.com>
Date: Wed, 15 Feb 2012 15:33:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Alexander Graf <agraf@suse.de>, qemu-devel <qemu-devel@nongnu.org>,
        kvm-ppc <kvm-ppc@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>	<51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>	<4F3117E5.6000105@redhat.com>	<EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>	<4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F3141E4.8080902@codemonkey.ws>
In-Reply-To: <4F3141E4.8080902@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 05:23 PM, Anthony Liguori wrote:
> On 02/07/2012 07:40 AM, Alexander Graf wrote:
>>
>> Why? For the HPET timer register for example, we could have a simple
>> MMIO hook that says
>>
>>    on_read:
>>      return read_current_time() - shared_page.offset;
>>    on_write:
>>      handle_in_user_space();
>>
>> For IDE, it would be as simple as
>>
>>    register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>>    for (i = 1; i<  7; i++) {
>>      register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>      register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>    }
>
> You can't easily serialize updates to that address with the kernel
> since two threads are likely going to be accessing it at the same
> time.  That either means an expensive sync operation or a reliance on
> atomic instructions.
>
> But not all architectures offer non-word sized atomic instructions so
> it gets fairly nasty in practice.
>

I doubt that any guest accesses IDE registers from two threads in
parallel.  The guest will have some lock, so we could have a lock as
well and be assured that there will never be contention.

-- 
error compiling committee.c: too many arguments to function

