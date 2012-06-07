Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2FGBFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:05:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37107 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2FGBFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <1338995150.9281.7.camel@wall-e>
References: <1338988998-9061-1-git-send-email-stefani@seibold.net>
	<CACVXFVPX-F820rgusEiC9F9XQNqYybi29Cd_hSyiN95c2OAWHg@mail.gmail.com>
	<1338995150.9281.7.camel@wall-e>
Date: Thu, 7 Jun 2012 09:05:30 +0800
Message-ID: <CACVXFVOurE3oaA5GLPkDQLeHP4sT4i0B0J_RPG_u2CL-VSFP7Q@mail.gmail.com>
Subject: Re: [PATCH] fix usb skeleton driver
From: Ming Lei <tom.leiming@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 11:05 PM, Stefani Seibold <stefani@seibold.net> wrote:
>>
>> This one is not needed since we have minor_rwsem(drivers/usb/core/file.c)
>> to avoid the race.
>>
>
> The mutex is not for the minor handling, it is for the disconnect(). As

usb_deregister_dev is called by disconnect, and usb_deregister_dev
will acquire minor_rwsem, so there is no race between open and disconnect.
When skel_open is being called, the minor_rwsem has been held already,
so disconnect() will staying on acquiring minor_rwsem.

So sync_mutex is not necessary at all.

> mentioned in the previous posting, there is a race betwenn open() and
> connect().
>
> Oliver told me that a interface pointer can be already used by an other
> driver when the disconnect() was called.

If you mean dev->interface, that is protected by io_mutex already.


Thanks,
-- 
Ming Lei
