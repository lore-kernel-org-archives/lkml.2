Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1F2KDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:03:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60663 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1F2KC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:02:58 -0400
Message-ID: <4E0AF84D.6050702@canonical.com>
Date: Wed, 29 Jun 2011 11:02:53 +0100
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 10/12] Input: synaptics - decode AGM packet types
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-11-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1309324042-22943-11-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 06:07 AM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> A Synaptics image sensor tracks 5 fingers, but can only report 2.
> This behavior is called "T5R2" = Track 5 Report 2
> 
> Algorithm for choosing which 2 fingers to report in which packet:
>   Touchpad maintains 5 slots, numbered 0 to 4.
>   Initially all slots are empty.
>   As new fingers are detected, they are assigned the lowest available
>   slot.
>   Touchpad always reports:
>     SGM: lowest numbered non-empty slot
>     AGM: highest numbered non-empty slot, if there is one.

Hi Daniel,

Thanks for the new patches! I will review them soon in detail, but I
would like to first confirm some details about the above.

In the older "profile" devices, we got essentially the bounding box of
all touches. This allows us to detect pinch gestures between the two
most extreme touches when there are three touches on the touchpad.

The above description makes it sound like we will no longer have a
bounding box of touches. According to the description, if I put four
fingers down in a square formation and then touch a fifth finger in the
middle of the square, I will only see the locations of one corner and
the middle of the square. This would make meaningful gesture detection
beyond two touches nearly impossible. Is this really how the touchpad
works, or is the above description not quite right?

Thanks!

-- Chase
