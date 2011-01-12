Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1ALKEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:04:40 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:37643 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1ALKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:04:37 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 05:04:37 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAEMJLU2ERHMGgWdsb2JhbACkPhUBARYiJLxbAoVKBIsQ
X-IronPort-AV: E=Sophos;i="4.60,312,1291586400"; 
   d="scan'208";a="25313232"
Date: Wed, 12 Jan 2011 11:54:28 +0200
From: "Nadav Har'El" <nyh@math.technion.ac.il>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: send IPI to vcpu only when it's in guest mode
Message-ID: <20110112095428.GA15835@fermat.math.technion.ac.il>
References: <4D2D5AA6.9080804@cn.fujitsu.com> <4D2D5AEF.1070006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2D5AEF.1070006@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Hebrew-Date: 7 Shevat 5771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011, Xiao Guangrong wrote about "[PATCH v3 2/3] KVM: send IPI to vcpu only when it's in guest mode":
> We can interrupt the vcpu only when it's running in guest mode
> to reduce IPI

Hi,

I am afraid there's a risk of confusion between the new

	vcpu->mode = IN_GUEST_MODE;

and the existing

	is_guest_mode()   (i.e., vcpu->arch.hflags & HF_GUEST_MASK)

The latter says that the virtual cpu is in guest mode (i.e., the guest used
VMLAUNCH and is runnning a nested guest), while the former says that the
physical CPU that this vcpu is currently being run on, is in guest mode - or
in other words, this vcpu is currently running.

I'm not sure what is the best way to resolve this potential for confusion.
Maybe on of them is better renamed (e.g., instead of vcpu->mode = IN_GUEST_MODE
have something like vcpu->running = NOW_RUNNING). Or maybe some good comments
need to to be written to explain the situation.

Actually, I just noticed that there's already a vcpu->guest_mode which you
are apparently replacing, so the potential for confusion is already in the
current code... I.e., in the current code, is_guest_mode(vcpu) does NOT check
vcpu->guest_mode...


-- 
Nadav Har'El                        |    Wednesday, Jan 12 2011, 7 Shevat 5771
nyh@math.technion.ac.il             |-----------------------------------------
Phone +972-523-790466, ICQ 13349191 |Hi! I'm a signature virus! Copy me into
http://nadav.harel.org.il           |your signature to help me spread!
