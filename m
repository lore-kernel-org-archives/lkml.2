Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2BGP2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:28:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab2BGP2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:28:39 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3141E4.8080902@codemonkey.ws>
Date: Tue, 7 Feb 2012 16:28:37 +0100
Cc: Avi Kivity <avi@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        kvm-ppc <kvm-ppc@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <0686DC7B-3503-4C57-9E2A-779D22961F50@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws>	<51470503-DEE0-478D-8D01-020834AF6E8C@suse.de>	<4F3117E5.6000105@redhat.com>	<EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>	<4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F3141E4.8080902@codemonkey.ws>
To: Anthony Liguori <anthony@codemonkey.ws>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.02.2012, at 16:23, Anthony Liguori wrote:

> On 02/07/2012 07:40 AM, Alexander Graf wrote:
>> 
>> Why? For the HPET timer register for example, we could have a simple MMIO hook that says
>> 
>>   on_read:
>>     return read_current_time() - shared_page.offset;
>>   on_write:
>>     handle_in_user_space();
>> 
>> For IDE, it would be as simple as
>> 
>>   register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>>   for (i = 1; i<  7; i++) {
>>     register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>     register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>   }
> 
> You can't easily serialize updates to that address with the kernel since two threads are likely going to be accessing it at the same time.  That either means an expensive sync operation or a reliance on atomic instructions.

Yes. Essentially we want a mutex for them.

> But not all architectures offer non-word sized atomic instructions so it gets fairly nasty in practice.

Well, we can always require fields to be word sized.


Alex

