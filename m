Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab1KWH2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:28:33 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:52780 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab1KWH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <20111123033850.GA11380@redhat.com>
References: <20111123033850.GA11380@redhat.com>
Date: Tue, 22 Nov 2011 23:28:31 -0800
Message-ID: <CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Havard Skinnemoen <hskinnemoen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
> From Linus' current tree...
>
> related to 5dc2470c602da8851907ec18942cd876c3b4ecc1 maybe ?

Yes, probably. I did have a bad feeling about the locking, but it
seemed to behave well during testing. Wonder why I didn't see this.

So what's happening is that tty_open() holds big_tty_mutex while
calling acm_tty_open which takes open_lock, and acm_tty_close holds
open_lock while calling tty_port_close_start which takes
big_tty_mutex?

Not sure how to solve this. Not taking the lock before calling
tty_port_close_start means the tty_port may get freed before it
returns.

Havard
