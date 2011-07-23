Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1GWBLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:11:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56226 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1GWBLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:11:39 -0400
Message-ID: <4E2A1FC5.90607@canonical.com>
Date: Fri, 22 Jul 2011 18:11:33 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 6/9 v2] Input: synaptics - process finger (<=3) transitions
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-7-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1311169146-20066-7-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Synaptics image sensor touchpads track 5 fingers, but only report 2.
> 
> This patch attempts to deal with some idiosyncrasies of these touchpads:
> 
>  * When there are 3 or more fingers, only two are reported.
>  * The number of fingers can change at any time, but is only reported in
>    SGM packets, thus at a number-of-fingers change, it is not possible
>    to tell whether the AGM finger is for the original or new number of
>    fingers.
>  * When the number of fingers changes from 2->3 it is not
>    possible to tell which of the 2 fingers are now reported.
>  * When number of fingers changes from 3->2 it is often not possible to
>    tell which finger was removed, and which are now being reported.
> 
> When 2 or more packets are present on the touchpad, the kernel reports
                 ^touches or fingers
