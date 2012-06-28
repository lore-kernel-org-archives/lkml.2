Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2F1M7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab2F1M7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:59:30 -0400
Message-ID: <4FEC552E.40409@redhat.com>
Date: Thu, 28 Jun 2012 15:59:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 6/6] kvm: Level IRQ de-assert for KVM_IRQFD
References: <20120627044758.23698.249.stgit@bling.home> <20120627051013.23698.91132.stgit@bling.home>
In-Reply-To: <20120627051013.23698.91132.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 08:10 AM, Alex Williamson wrote:
> This is an alternate level irqfd de-assert mode that's potentially
> useful for emulated drivers.  It's included here to show how easy it
> is to implement with the new level irqfd and eoifd support.  It's
> possible this mode might also prove interesting for device-assignment
> where we inject via level irqfd, receive an EOI (w/o de-assert), and
> use the level de-assert irqfd here.

This use case is racy.  The guest driver will have shut down the
interrupt before EOI, but with what you describe, it will fire again
until the eoifd/deassertfd sequence completes.

An emulated device will see the guest driver shutting down the interrupt
so it's not a problem there.

-- 
error compiling committee.c: too many arguments to function


