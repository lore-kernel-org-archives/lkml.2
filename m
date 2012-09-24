Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab2IXSqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:46:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46613 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2IXSq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:46:29 -0400
Date: Mon, 24 Sep 2012 15:46:22 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-09-18
Message-ID: <20120924184622.GA7922@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120919013113.GG24689@joana>
 <CAB=NE6XKNSMeS3_uzcGsGBhcm6ZKtJwJ=DdAq_DoWmKTXQvV=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAB=NE6XKNSMeS3_uzcGsGBhcm6ZKtJwJ=DdAq_DoWmKTXQvV=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luis R. Rodriguez <mcgrof@do-not-panic.com> [2012-09-21 18:06:42 -0700]:

> On Tue, Sep 18, 2012 at 6:31 PM, Gustavo Padovan <gustavo@padovan.org> wrote:
> 
> > Johan Hedberg (2):
> >       Bluetooth: mgmt: Implement support for passkey notification
> 
> Too late now... but why did we allow this a stable fix? I get its a
> feature that is important and likely overlooked / someone had a brain
> fart, but from what I gather this is not on v3.5.4 and yet may make it
> to v3.5.5. At least for backporting this was a bitch:
> 
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3290:52:
> error: dereferencing pointer to incomplete type
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3294:6:
> error: ‘struct hci_conn’ has no member named ‘passkey_notify’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3294:25:
> error: dereferencing pointer to incomplete type
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3295:6:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3298:3:
> error: implicit declaration of function ‘mgmt_user_passkey_notify’
> [-Werror=implicit-function-declaration]
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3299:27:
> error: ‘struct hci_conn’ has no member named ‘passkey_notify’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3300:11:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:
> In function ‘hci_keypress_notify_evt’:
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3310:52:
> error: dereferencing pointer to incomplete type
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3314:12:
> error: dereferencing pointer to incomplete type
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3315:7:
> error: ‘HCI_KEYPRESS_STARTED’ undeclared (first use in this function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3315:7:
> note: each undeclared identifier is reported only once for each
> function it appears in
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3316:7:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3319:7:
> error: ‘HCI_KEYPRESS_ENTERED’ undeclared (first use in this function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3320:7:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3323:7:
> error: ‘HCI_KEYPRESS_ERASED’ undeclared (first use in this function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3324:7:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3327:7:
> error: ‘HCI_KEYPRESS_CLEARED’ undeclared (first use in this function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3328:7:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3331:7:
> error: ‘HCI_KEYPRESS_COMPLETED’ undeclared (first use in this
> function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3337:27:
> error: ‘struct hci_conn’ has no member named ‘passkey_notify’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3338:11:
> error: ‘struct hci_conn’ has no member named ‘passkey_entered’
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:
> In function ‘hci_event_packet’:
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3701:7:
> error: ‘HCI_EV_USER_PASSKEY_NOTIFY’ undeclared (first use in this
> function)
> /home/mcgrof/staging/v3.5.4/compat-wireless-3.5.3-2-snpc/net/bluetooth/hci_event.c:3705:7:
> error: ‘HCI_EV_KEYPRESS_NOTIFY’ undeclared (first use in this
> function)
> 
> I'd much prefer to see things like these identified as 'important' but
> not 'fuck, this fixes that crash'. The fact that kernel maintainers
> may be anal about these sorts of patches is *good* for many reasons
> and figuring out a way to categorize, identify and allow users to reap
> benefits of backporting suck fixes / cherry picking a full solution is
> what something that should not interfere and hopefully be transparent
> to Linux upstream development.
> 
> Here's one way I dealt with these type of patches:
> 
> https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/additional-patches
> 
> If you look at the patch 'Bluetooth: mgmt: Implement support for
> passkey' its  a clear "feature" implementation, not a fucking fix.

Yes, this patch is wrongly marked as stable, it is not even going to 3.5. I'm
just removing the tag from it and resending the pull request to John.

	Gustavo
