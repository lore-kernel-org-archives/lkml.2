Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2HOLme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab2HOLmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:42:32 -0400
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is panicked
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Yan Vugenfirer <yvugenfi@redhat.com>
In-Reply-To: <20120815095630.GT11194@redhat.com>
Date: Wed, 15 Aug 2012 14:42:20 +0300
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <68E3ABCF-001F-4611-AB98-5069D25AC90C@redhat.com>
References: <5021D235.4050800@cn.fujitsu.com> <20120813182132.GB25268@amt.cnet> <20120814085619.GA32708@redhat.com> <502A2B7A.3070801@siemens.com> <86E2467F-0EA3-4A03-BD89-58E41F7DB808@redhat.com> <20120814154237.GA21284@amt.cnet> <87boidgvaq.fsf@codemonkey.ws> <20120814191927.GA6058@amt.cnet> <87txw5clmh.fsf@codemonkey.ws> <20120815095630.GT11194@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15, 2012, at 12:56 PM, Gleb Natapov wrote:

> On Tue, Aug 14, 2012 at 02:35:34PM -0500, Anthony Liguori wrote:
>>> Do you consider allowing support for Windows as overengineering?
>> 
>> I don't think there is a way to hook BSOD on Windows so attempting to
>> engineer something that works with Windows seems odd, no?
>> 
> Yan says in other email that is is possible to register a bugcheck callback.
> 

Here you go - http://msdn.microsoft.com/en-us/library/windows/hardware/ff553105(v=vs.85).aspx
Already done in virtio-net for two reasons: 1. we could configure virtio-net to notify QEMU in a hacky way (write 1 to VIRTIO_PCI_ISR register) that there was a bugckeck .It was very useful debugging complex WHQL issues that involved host networking. 2. Store additional information (for example time stamps of last receive packet, last interrupt and etc) in crash dump.

Yan.

> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

