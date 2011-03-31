Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab1CaIbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:31:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43401 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933802Ab1CaIbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:31:35 -0400
Date: Thu, 31 Mar 2011 10:30:54 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Lee, Chun-Yi" <jlee@novell.com>
Subject: Re: [PATCH] acer-wmi: does not set persistence state by
 rfkill_init_sw_state
Message-ID: <20110331103054.73438ab5@schatten.dmk.lab>
In-Reply-To: <1301516277-1752-1-git-send-email-florian@mickler.org>
References: <1301516277-1752-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 22:17:57 +0200
Florian Mickler <florian@mickler.org> wrote:

> From: Lee, Chun-Yi <joeyli.kernel@gmail.com>
> 
> Acer BIOS keeps devices state when system reboot, but reset to default
> device states (Wlan on, Bluetooth off, wwan on) if system cold boot.
> That means BIOS's initial state is not always real persistence.
> 
> So, removed rfkill_init_sw_state because it sets initial state to
> persistence then replicate to other new killswitch when rfkill-input
> enabled.
> After removed it, acer-wmi set initial soft-block state after rfkill
> register, and doesn't allow set_block until rfkill initial finished.
> 
> Reference: bko#31002
> 	https://bugzilla.kernel.org/show_bug.cgi?id=31002
> 
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Tested-by: OldÅich JedliÄka <oldium.pro@seznam.cz>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> This fixes a regression, but no stable annotation was given...
> 
> Oversight? Matthew/Chun-Yi please take a look. 
> 

I forgot: This is upstream
commit 8215af019040ce9182728afee9642d8fdeb17f59 .

As for the Tested-by:, I think that's borked in git. At least I can't
get it out of git correctly. It should be:
Tested-by: Oldřich Jedlička <oldium.pro@seznam.cz> 

Thanks,
Flo

