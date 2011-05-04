Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1EDDuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:50:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51198 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1EDDuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tlPF2Mftf7KdN8oON76fej/QbIC26PAVuZrH6tSzm5RS0u2JeHjx6cYk8zbhccsBAP
         EmR+3YJo8DXSGgV84FfUYiBzGvhKUlEelt4y08yMMugG+YtWTChv5fqhjGP4pLa6LTd7
         BlK4IByxjPKvLVsuOO2ESKDOUlHqQlFrsDCI8=
MIME-Version: 1.0
In-Reply-To: <20110502004940.2307.71738.stgit@ul30vt.home>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
	<20110502004940.2307.71738.stgit@ul30vt.home>
Date: Wed, 4 May 2011 13:50:19 +1000
Message-ID: <BANLkTi==E4wgRDY3DCDejAZtVvOGjOtbgA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/nouveau: Check that the device is enabled before
 processing interrupt
From: Dave Airlie <airlied@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 10:49 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> We're likely to be sharing an interrupt line with other devices,
> which means our handler might get called after we've turned off
> the device via vga switcheroo.  This can lead to all sorts of
> badness, like nv04_fifo_isr() spewing "PFIFO still angry after
> 100 spins, halt" to the console before the system enters a hard
> hang.
>
> We can avoid this by simply checking if the device is still
> enabled before processing an interrupt.  To avoid races, flush
> any inflight interrupts using synchronize_irq().  Note that
> since pci_intx() is called after pci_save_state(),
> pci_restore_state() will automatically re-enable INTx.

I still think we should just need the synchronize_irq followed by a
check in the irq handler for all fs,

or is there a race there I'm missing?

Dave.
