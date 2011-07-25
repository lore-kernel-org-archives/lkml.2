Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1GYJtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:49:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:49:24 -0400
Message-ID: <4E2D3BF1.7070406@redhat.com>
Date: Mon, 25 Jul 2011 12:48:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <20110725085426.GA28787@elte.hu> <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de> <20110725094136.GE28787@elte.hu>
In-Reply-To: <20110725094136.GE28787@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 12:41 PM, Ingo Molnar wrote:
> Look at tools/kvm/ - i cannot do anything useful without a Linux
> kernel under it. It's as deeply bound to the Linux kernel as it gets.

The actual code that interacts with the kernel is pretty small, and will 
grow smaller (as a fraction) in time.

> Then look at the actual drivers and interfaces within tools/kvm/.
> It's using the same symbols and conventions for 'guest' and 'host'
> side.
>
> Check out tools/kvm/hw/i8042.c and match it up with
> include/linux/serio.h and drivers/input/serio/i8042.c - you can
> literally walk from one side to the other and understand how guest
> and host are tightly related not just functionality but also
> implementation wise.
>
> This is how Qemu should be doing it as well btw., to ease the
> debugging of host/guest interaction bugs and to ease development.

No.  That ties the guest and host interfaces together.  If you change 
the guest to use a feature you didn't implement previously in the host, 
it's suddenly broken when virtualized.

The right thing is to implement the hardware interface exactly per spec, 
and ignore the guest(s) completely except for testing and performance.


-- 
error compiling committee.c: too many arguments to function

