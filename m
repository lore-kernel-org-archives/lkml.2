Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2LCTBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:01:39 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49686 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2LCTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:01:38 -0500
Date: Mon, 3 Dec 2012 13:46:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-12-03
Message-ID: <20121203184628.GG26027@tuxdriver.com>
References: <20121203182208.GB2930@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121203182208.GB2930@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:22:08PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> A few more patches to 3.8, I hope they can still make it to mainline!
> The most important ones are the socket option for the SCO protocol to allow
> accept/refuse new connections from userspace. Other than that I added some
> fixes and Andrei did more AMP work.
> 
> Please pull, or let me know any concerns you have. Thanks!
> 
> 	Gustavo

Pulled...

> ---
> The following changes since commit 2b2fec4d08a0aabe20d2e749cb7978f04217af65:
> 
>   Bluetooth: Remove OOB data if device was discovered in band (2012-11-20 16:03:15 -0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 0b27a4b97cb1874503c78453c0903df53c0c86b2:
> 
>   Revert "Bluetooth: Fix possible deadlock in SCO code" (2012-12-03 16:00:04 -0200)
> 
> ----------------------------------------------------------------
> Andrei Emeltchenko (6):
>       Bluetooth: Refactor l2cap_send_disconn_req
>       Bluetooth: AMP: Mark controller radio powered down after HCIDEVDOWN
>       Bluetooth: AMP: Check that AMP is present and active
>       Bluetooth: Fix missing L2CAP EWS Conf parameter
>       Bluetooth: Process receiving FCS_NONE in L2CAP Conf Rsp
>       Bluetooth: trivial: Change NO_FCS_RECV to RECV_NO_FCS
> 
> Frédéric Dalleau (2):
>       Bluetooth: Add BT_DEFER_SETUP option to sco socket
>       Bluetooth: Implement deferred sco socket setup
> 
> Gustavo Padovan (4):
>       Bluetooth: Add missing lock nesting notation
>       Bluetooth: cancel power_on work when unregistering the device
>       Bluetooth: Move double negation to macros
>       Revert "Bluetooth: Fix possible deadlock in SCO code"
> 
>  include/net/bluetooth/hci_core.h |  31 ++++++++++---
>  include/net/bluetooth/l2cap.h    |   2 +-
>  net/bluetooth/hci_core.c         |   5 +++
>  net/bluetooth/hci_event.c        |  56 ++++++++++++++++++++---
>  net/bluetooth/l2cap_core.c       | 100 +++++++++++++++++++++--------------------
>  net/bluetooth/mgmt.c             |  10 ++---
>  net/bluetooth/rfcomm/sock.c      |   4 +-
>  net/bluetooth/sco.c              |  86 ++++++++++++++++++++++++++++++-----
>  8 files changed, 213 insertions(+), 81 deletions(-)



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
