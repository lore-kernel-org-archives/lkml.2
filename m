Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab3AIWmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab3AIWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:42:51 -0500
Message-ID: <1357771504.12030.59.camel@dcbw.foobar.com>
Subject: Re: sd8688 firmware location
From: Dan Williams <dcbw@redhat.com>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 09 Jan 2013 16:45:04 -0600
In-Reply-To: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 00:56 +0100, Lubomir Rintel wrote:
> Hi!
> 
> btmrvl_sdio and libertas_sdio both use firmware files sd8688.bin and
> sd8688_helper.bin. In linux-firmware, they're present in libertas/ tree and
> (since 3d32a58b) libertas_sdio perfers loading it from there, while it is able
> to fallback to load it from linux-firmware root. btmrvl_sdio, on the other hand
> only looks in the root and ends up not being successful.
> 
> Obviously, there are two solutions to the problem -- either teach btmrvl_sdio
> to look into libertas/, or move the files in linux-firmware tree. I don't
> really have a strong preference, though it probably makes less sense to keep in
> in libertas/, since the bluetooth hardware is not really marketed as "Libertas."
> 
> I'm following up with patches to linux and linux-firmware and I'd be very
> thankful if you could pick one (not both of them).

So the BT part and the wifi part have different SDIO IDs; are they
actually connected separately to the SDIO bus?  Or is the chip only in
one mode at one time or something like that?  Is there a problem with
having both libertas and btmrvl loaded at the same time since they're
essentially the same chip?

I don't really mind moving stuff to mrvl/ out of libertas/ for these
devices, but I do want some backwards compat code in libertas for that.
Unless, of course, Marcel was talking about symlinks in the
linux-firmware git tree, which would be fine with me.  The important
point is that simply updating your linux-firmware package or install or
whatever *should not* result in a failed firmware load.

Dan

