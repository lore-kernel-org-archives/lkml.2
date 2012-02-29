Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814Ab2B2HYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:24:09 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53572 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030750Ab2B2HYG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:24:06 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format specifier
Date: Wed, 29 Feb 2012 08:22:58 +0100
User-Agent: KMail/1.9.10
Cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1330091162-8141-4-git-send-email-danny.kukawka@bisect.de> <20120228.154914.662485432055205683.davem@davemloft.net> <CAMuHMdUudso1YpukfxvGdb2fAYZBJewTgQEh-aU_KB0-U2o6WQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUudso1YpukfxvGdb2fAYZBJewTgQEh-aU_KB0-U2o6WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201202290822.59640.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330500246;23b37ce1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 28. Februar 2012, Geert Uytterhoeven wrote:
> Hi David,
>
> 2012/2/28 David Miller <davem@davemloft.net>:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > Date: Tue, 28 Feb 2012 21:45:30 +0100
> >
> >> drivers/net/ethernet/cirrus/mac89x0.c: In function ‘set_mac_address’:
> >> drivers/net/ethernet/cirrus/mac89x0.c:597: warning: dereferencing
> >> ‘void *’ pointer
> >> drivers/net/ethernet/cirrus/mac89x0.c:597: error: request for member
> >> ‘sa_data’ in something not a structure or union
> >> drivers/net/ethernet/cirrus/mac89x0.c:600: warning: dereferencing
> >> ‘void *’ pointer
> >> drivers/net/ethernet/cirrus/mac89x0.c:600: error: request for member
> >> ‘sa_data’ in something not a structure or union
> >> drivers/net/ethernet/cirrus/mac89x0.c:595: warning: unused variable
> >> ‘saddr’
> >
> > Thanks, I've fixed this as follows and pushed to net-next:
> >
> > --------------------
> > mac89x0: Fix build error.
> >
> > Need to use the new 'saddr' variable not the void 'addr' in
> > set_mac_address().
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
Thanks for the fix!

> Thanks, that fixed the build.
>
> What about the is_valid_ether_addr() check?

If you mean the discussion about checking if the MAC is valid in
.ndo_set_mac_address, I'm on that issue and will hopefully send a patch soon.

Danny
