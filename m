Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2LCQDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:03:12 -0500
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:38785 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293Ab2LCQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:03:11 -0500
Message-ID: <50BCCD4C.8050209@microgate.com>
Date: Mon, 03 Dec 2012 10:03:24 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <20121202151332.3b6a6504@pyramind.ukuu.org.uk> <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com> <20121202181057.097012c6@pyramind.ukuu.org.uk> <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com> <50BC0C84.4060802@asianux.com>
In-Reply-To: <50BC0C84.4060802@asianux.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/2012 8:20 PM, Chen Gang wrote:
> pardon (I am just learning)
>   does 65535 mean HDLC_MAX_FRAME_SIZE ?
>   why do we need info->max_frame_size >= 4096 ?
> in drivers/tty/synclink_gt.c:
> 3550         if (info->max_frame_size < 4096)
> 3551                 info->max_frame_size = 4096;
> 3552         else if (info->max_frame_size > 65535)
> 3553                 info->max_frame_size = 65535;
> 3554
>  ...
> 3603                 info->max_frame_size = 4096;

The hardware can send and receive HDLC frames up to
64K in size. The driver defaults to 4K max frame size
to save buffer space for the common case
(line 3603 in alloc_dev()).

The module parameter max_frame_size can override the default
in add_device() (lines 3550-3554 are from add_device()
range checking the module parameter)

> if possible:
>   can we move the relative comments (which are inside function) to the
> location just above ldisc_receive_buf ?

The added comment from my first patch described the reuse
of the data buffer as the flag buffer. Alan prefers to use
a zero initialized dummy buffer for the flag buffer argument.
Doing it that way, the comment is not needed.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982 (US Sales)
(512)345-7791 x102 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -6h)
www.microgate.com
