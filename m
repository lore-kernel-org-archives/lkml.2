Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1BXQbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1BXQbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:31:52 -0500
Date: Thu, 24 Feb 2011 11:28:19 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: Can't build in the virtio console driver on x86_64 when the other
 virtio drivers are modular
Message-ID: <20110224112819.10f59f68@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtio configuration options are inconsistent. According to this,
every options that needs virtio will select it:

 # Virtio always gets selected by whoever wants it.
 config VIRTIO
        tristate

Note that it's not user-selectable, so any config file that tries to
set it will be ignored when kconfig loads those options. And yet we
have a whole set of options that depend on VIRTIO, like VIRTIO_CONSOLE
for example. This makes it impossible to have VIRTIO_PCI modular and
VIRTIO_CONSOLE built-in on x86_64, because:

1. VIRTIO_PCI selects VIRTIO and sets it to M
2. VIRTIO_CONSOLE gets forced to M because one of its dependencies is M

So either VIRTIO (and VIRTIO_RING) need to be user-selectable, or all
of the options that depend on VIRTIO need to be changed to select it
instead.

(For even more fun, LGUEST_GUEST on i386 forces VIRTIO, VIRTIO_RING and
VIRTIO_CONSOLE all to Y.)

