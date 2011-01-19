Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1ASS0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:26:31 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58763 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1ASS0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:26:30 -0500
MIME-Version: 1.0
X-Originating-IP: [134.191.244.34]
In-Reply-To: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
References: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
Date: Wed, 19 Jan 2011 23:56:29 +0530
Message-ID: <AANLkTinPC-i2xi9pCQ-RzGWuwZ5uTM3NXG7y6gwTnPYv@mail.gmail.com>
Subject: Re: [RFC 0/2] remove BT references from TI_ST
From: Pavan Savoy <pavan_savoy@sify.com>
To: padovan@profusion.mobi, marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo,

On Tue, Jan 4, 2011 at 4:29 PM,  <pavan_savoy@ti.com> wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
>
> Gustavo,
>
> Based on your comments, that the underlying shared transport driver
> for btwilink driver made use of the BT references to peek into the packets
> I have modified the TI_ST.

Since there lacks a generic way to parse the packets coming in from the
UART into BT, FM or GPS, we have to look into the data to fragment assembled
data or assemble fragmented data.

Please have a look, Please suggest whether something like this is required,
If not, please also suggest, if including BT headers is a problem ?

Because I just include the BT headers and don't have a build
dependency as such on
BT/HCI and don't use any functions from hci_core in my shared transport driver.

> For this reason, Now the above lying protocol drivers like BT, FM and GPS
> would send details about their packet types and header information which
> would assist shared transport driver to parse the data.
>
> Gustavo, please also notice the change in btwilink driver in and around,
> st_register and suggest if something like this is OK.
> btwilink can also be modified to send in all the packet specific data
> in one shot, if that is preferred.
>
> Please review and provide comments..
>
> Note:
> If this is alright, I will send out a modified patch with updated
> subject to lkml/Greg for linux-next.
>
> Thanks & Regards,
> Pavan Savoy.
>
> Pavan Savoy (2):
>  drivers:misc:ti-st: change protocol parse logic
>  Bluetooth: btwilink driver
>
>  drivers/bluetooth/Kconfig    |   10 +
>  drivers/bluetooth/Makefile   |    1 +
>  drivers/bluetooth/btwilink.c |  397 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/ti-st/st_core.c |  355 ++++++++++++--------------------------
>  drivers/misc/ti-st/st_kim.c  |   56 +++---
>  include/linux/ti_wilink_st.h |   40 +++--
>  6 files changed, 575 insertions(+), 284 deletions(-)
>  create mode 100644 drivers/bluetooth/btwilink.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
