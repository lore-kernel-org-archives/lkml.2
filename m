Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2DPLwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:52:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50630 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2DPLwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <1334573285-24016-1-git-send-email-hare@suse.de>
References: <1334573285-24016-1-git-send-email-hare@suse.de>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 16 Apr 2012 13:51:46 +0200
Message-ID: <CAPXgP11S6R4L-8tZ4cPY=MZfcvTBBHkUdTvt7FTKhvhVF6uKPQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: check 'start' argument in bus iterators
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Kay Sievers <ksievers@vrfy.org>, Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 12:48, Hannes Reinecke <hare@suse.de> wrote:
> bus_for_each_dev() and bus_find_device() both take a 'start'
> argument to start the iteration at a specific list entry.
> However, this list entry might already been detached by
> the time these functions are called.
> So we need to check if the arguments are still valid.

> +       if (start && !klist_node_attached(&start->p->knode_bus))
> +               return -ENODEV;
> +
>        klist_iter_init_node(&bus->p->klist_devices, &i,
>                             (start ? &start->p->knode_bus : NULL));

Shouldn't we do this check in klist_iter_init_node()?
After a kref_get(), and return -ENODEV from there if the node it as
asked to start is gone?

This check otherwise still has the window between the check and the
use of it, only very unlikely to hit now, hasn't it?

Kay
