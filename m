Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab2GDIg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:36:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34225 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2GDIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:36:22 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.10.162]
In-Reply-To: <CAEvN+1i8O-GhJ1s9mpeG1WvX850AjezCHgdsjQop6syP3pJPhQ@mail.gmail.com>
References: <CAEvN+1i8O-GhJ1s9mpeG1WvX850AjezCHgdsjQop6syP3pJPhQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 4 Jul 2012 11:36:01 +0300
Message-ID: <CAK=Wgbabj+FXuZhyT9hQNkxozbZJRBLR8TeUxfpCf3B1pwr15Q@mail.gmail.com>
Subject: Re: How the registration of rpmsg devices should be done?
To: Tzu-Jung Lee <roylee17@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 4, 2012 at 11:26 AM, Tzu-Jung Lee <roylee17@gmail.com> wrote:
> I working on the IPC functionality on our SoC and is looking into the
> rpmsg & remoteproc framework of inux v3.4.

Great! Which SoC are you working on ?

> Since rpmsg_create_channel() is static and internal to rpmsg module,
> I'm wondering how the registration of rpmsg device should be done?

>From Documentation/rpmsg.txt:

"4. Allocations of rpmsg channels:

At this point we only support dynamic allocations of rpmsg channels.

This is possible only with remote processors that have the VIRTIO_RPMSG_F_NS
virtio device feature set. This feature bit means that the remote
processor supports dynamic name service announcement messages.

When this feature is enabled, creation of rpmsg devices (i.e. channels)
is completely dynamic: the remote processor announces the existence of a
remote rpmsg service by sending a name service message (which contains
the name and rpmsg addr of the remote service, see struct rpmsg_ns_msg).

This message is then handled by the rpmsg bus, which in turn dynamically
creates and registers an rpmsg channel (which represents the remote service).
If/when a relevant rpmsg driver is registered, it will be immediately probed
by the bus, and can then start sending messages to the remote service.

The plan is also to add static creation of rpmsg channels via the virtio
config space, but it's not implemented yet."

Best,
Ohad.
