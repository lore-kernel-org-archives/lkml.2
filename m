Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2F1Mlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:41:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2F1Mli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:41:38 -0400
Message-ID: <4FEC50FD.6030402@redhat.com>
Date: Thu, 28 Jun 2012 15:41:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
References: <20120627044758.23698.249.stgit@bling.home>  <20120627050937.23698.68442.stgit@bling.home>  <20120627093427.GE17507@redhat.com> <1340831986.1207.250.camel@bling.home>
In-Reply-To: <1340831986.1207.250.camel@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 12:19 AM, Alex Williamson wrote:
>> > @@ -302,6 +385,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>> >  {
>> >  	struct _irqfd *irqfd, *tmp;
>> >  	struct eventfd_ctx *eventfd;
>> > +	bool is_level = (args->flags & KVM_IRQFD_FLAG_LEVEL) != 0;
>> 
>> != 0 is not needed here I think.
> 
> Strictly, no it's not.  I just prefer to set bools from bools and I
> think Avi has commented on using !! before.

I prefer the naked version too, but != 0 is acceptable.
-- 
error compiling committee.c: too many arguments to function


