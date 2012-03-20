Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519Ab2CTPNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:13:40 -0400
Received: from [89.21.227.130] ([89.21.227.130]:40576 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755043Ab2CTPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:13:39 -0400
Message-ID: <4F689E9F.90902@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:13:35 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
Subject: Re: [PATCH 12/20] Input: atmel_mxt_ts - simplify event reporting
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-13-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-13-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> Instead of carrying around per-finger state in the driver instance, just
> report each finger as it arrives to the input layer, and let the input
> layer (evdev) hold the event state (which it does anyway).
>
> Also, the atmel pad reports "amplitude", which is reported to userspace
> using the "PRESSURE" event type.  The variables now reflect this.
> 
> Note: this driver does not really do MT-B properly. Each input report
> (a goup of input events followed by a SYN_REPORT) only contains data for
> a single contact.  When multiple fingers are present on a device, each is
> properly reported in its own MT_SLOT.  However, there is only ever one
> MT_SLOT per SYN_REPORT.  This is fixed in a subsequent patch.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

This seems to be a good improvement, assuming it is valid. Which platforms
have you tested it on?

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
