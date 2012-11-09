Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2KIUSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:18:02 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33258 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2KIUSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:18:00 -0500
MIME-Version: 1.0
In-Reply-To: <20121106015835.GA11971@localhost.localdomain>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
 <20121031011256.GC12325@amt.cnet> <50908354.5070608@cn.fujitsu.com>
 <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com> <20121106015835.GA11971@localhost.localdomain>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 9 Nov 2012 15:17:39 -0500
Message-ID: <CA+1xoqd60YihExEuSU2qzsyFRXLS=XaeeX9AaMLhPHggfM6V3A@mail.gmail.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 8:58 PM, Hu Tao <hutao@cn.fujitsu.com> wrote:
> But in the case of panic notification, more dependency means more
> chances of failure of panic notification. Say, if we use a virtio device
> to do panic notification, then we will fail if: virtio itself has
> problems, virtio for some reason can't be deployed(neither built-in or
> as a module), or guest doesn't support virtio, etc.

Add polling to your virtio device. If it didn't notify of a panic but
taking more than 20 sec to answer your poll request you can assume
it's dead.

Actually, just use virtio-serial and something in userspace on the guest.

> We choose IO because compared to virtio device, it is not that heavy and
> less problematic.

Less problematic? Heavy? Are there any known issues with virtio that
should be fixed? You make virtio sound like an old IDE drive or
something.


Thanks,
Sasha
