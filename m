Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1DZPtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:49:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44340 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1DZPth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:49:37 -0400
Date: Tue, 26 Apr 2011 12:49:50 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Imran Haider <imran1008@gmail.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Don't sleep after deleting command timer
Message-ID: <20110426154950.GA2242@joana>
Mail-Followup-To: Imran Haider <imran1008@gmail.com>, marcel@holtmann.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1303513362-9357-1-git-send-email-imran1008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303513362-9357-1-git-send-email-imran1008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imran,

* Imran Haider <imran1008@gmail.com> [2011-04-22 19:02:42 -0400]:

> This fix adds on to commit b77dcf84. It seems that scheduling a timeout
> of 250ms after deleting the command timer causes a kernel panic when
> system is resuming from Suspend-to-RAM. I tried adding another timeout
> before deleting the command timer but that didn't help so I believe that
> some code in hci_dev_do_close must execute after the command timer is
> deleted before control is returned to another thread.
> 
> The only bit the command timer handler hci_cmd_timer() touches is HCI_RESET.
> It should be fine to delete the timer after testing the HCI_UP bit.
> ---
>  net/bluetooth/hci_core.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)

I already have for that. But thanks anyway. ;)

-- 
Gustavo F. Padovan
http://profusion.mobi
