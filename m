Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0IAR7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:59:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0IAR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTiktz6bc6Ue9OKZ0ejSqf7GH4z50JeUvidxHbrSw@mail.gmail.com>
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
 <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>
 <1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com> <4C7CC107.1050304@redhat.com>
 <4C7D0DAD.9030505@redhat.com> <4C7D141A.9060102@redhat.com>
 <4C7D1868.3090701@redhat.com> <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>
 <4C7D1E1B.4020700@redhat.com> <1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>
 <4C7D248A.2080507@redhat.com> <AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>
 <1283287898.3284.183.camel@dhcp231-106.rdu.redhat.com> <AANLkTiktz6bc6Ue9OKZ0ejSqf7GH4z50JeUvidxHbrSw@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 1 Sep 2010 19:59:23 +0200
Message-ID: <AANLkTinbfYMN4gejCEB7UJooa5m68gbX_o6amrdo07Oo@mail.gmail.com>
Subject: Re: selinux vs devtmpfs (vs udev)
To: Stephen Smalley <stephen.smalley@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Harald Hoyer <harald@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, greg@kroah.com, sds@tycho.nsa.gov
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 18:08, Stephen Smalley <stephen.smalley@gmail.com> wrote:
> Maybe we should back up and ask the udev folks how they think libvirt
> labeling should be done so as to not conflict with udev labeling, e.g.
> should libvirt be going through udev to assign the labels.

The current idea is that udev only labels the device on bootup once,
or when a new device is discovered, and never changes it again (unless
someone will synthesize 'add' events, which should not happen).

The behavior described in the initial bug is just a plain udev bug.
With the fix Harald put in, it should behave as described above. That
can all be changed though, if needed, and if something else makes
sense.

Kay
