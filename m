Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1APCAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 21:00:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1APCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 21:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sK+aypq/NAQgY5D75UkGYn03qEr1Wbx6kCImiOWNH2XhQb373e0sWXKEh4o9x7DxnC
         4ltZg6FgIbDNvlqrjfwTzChMtnVZjXFMi/RuJ8cvI8BCTz96Zykhy/pK8HnVgsOwaN4a
         H+ydc4u8/S1qa180G2YnykPlbzBiTwOJI3oMI=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
Date: Sun, 16 Jan 2011 02:59:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-wl-default+; KDE/4.5.5; x86_64; ; )
Cc: Ingo Brunberg <ingo_brunberg@web.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <m31v4hkmkf.fsf@ingo.homenetwork> <201101131423.51640.helmut.schaa@googlemail.com> <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
In-Reply-To: <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101160259.14404.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 15. Januar 2011 schrieb Ivo Van Doorn:
> Hi,
> 
> > Just a shot in the dark but since the stack trace shows the newly added
> > watchdog this might be the result of a race between a regular txdone work
> > (mac80211 workqueue) vs the watchdog work (global workqueue).
> >
> > I guess the following situation could happen:
> > A regular tx done work calls rt2x00lib_txdone which first sets entry->skb to
> > NULL, calls the driver specific clear_entry and afterwards increases
> > Q_INDEX_DONE. If the watchdog work calls rt2x00lib_txdone on a different CPU
> > inbetween the skb might be NULL and cause the above oops.
> 
> This could be, would be interesting to know if compat-wireless also shows
> this problem. Because the queue refactoring code which should have solved
> these race conditions was added after 2.6.37.

I also guess that this issue would be fixed in compat-wireless due to the queue
refactoring. But I guess that is way too big for a stable kernel :(

Helmut
