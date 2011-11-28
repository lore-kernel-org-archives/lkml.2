Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1K1SPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:15:18 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36298 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1K1SPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:15:17 -0500
MIME-Version: 1.0
In-Reply-To: <1322429863-10383-1-git-send-email-hskinnemoen@google.com>
References: <1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<1322429863-10383-1-git-send-email-hskinnemoen@google.com>
Date: Mon, 28 Nov 2011 10:15:16 -0800
Message-ID: <CAFQmdRawtiWUW6y2-5G9LXdn5rEZb7raC=SJ09AnzLYQ_vYC+A@mail.gmail.com>
Subject: Re: [RFC v2] cdc-acm: Fix potential deadlock (lockdep warning)
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Oliver Neukum <oliver@neukum.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Havard Skinnemoen <hskinnemoen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 1:37 PM, Havard Skinnemoen
<hskinnemoen@google.com> wrote:
> -       if (0 > acm_set_control(acm, acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS) &&
> +       acm->ctrlout = ACM_CTRL_DTR | ACM_CTRL_RTS;
> +       if (acm_set_control(acm, acm->ctrlout < 0) &&

Ok, so this is obviously broken. Unfortunately, my test setup doesn't
use the control signals in any way.

I'm sure I broke something else, so I'm going to wait a bit for others
to have a look before I post an updated patch.

Havard
