Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0CSUqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:46:43 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33905 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab0CSUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:46:42 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Subject: [RFC/PATCH 0/4] VMware balloon driver over virtio
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com, Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 19 Mar 2010 13:46:41 -0700
Message-ID: <20100319204628.4418.84674.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

VMware would like to get its Linux balloon driver merged into mainline
and is considering doing it within virtio framework.

The following is the initial implementation of our ballooning interface
as a virtio device. It allows our hypervisor to work in tandem with
virtio_balloon driver and inflate and deflate balloon on demand.

Due to the fact that our monitor works a bit differently from KVM some
changes are needed in virtio_balloon itself, namely:

- our hypervisor may refuse locking certain pages. This may happen,
  for example, when target balloon size is changed since guest polled
  it last time. We expect guest to try locking different page and
  release refused pages once target balloon size is reached.

- our hypervisor may, in certain situations, reset the balloon. In this
  case it expects guest to quickly release all memory allocated by
  by the balloon but to not bother telling the host about pages being
  released.

There are more differences (adaptive allocation rates, sleeping
allocations) which we intend to address at a later date if it is
decided that virtio is the proper subsystem to be used for our
driver.

Thanks!

-- 
Dmitry
