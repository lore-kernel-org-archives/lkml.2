Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2GRPi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:38:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2GRPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:38:27 -0400
Message-ID: <5006D86C.7030208@canonical.com>
Date: Wed, 18 Jul 2012 08:38:20 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120620 Thunderbird/14.0
MIME-Version: 1.0
To: Chung-yih Wang <cywang@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>, JJ Ding <dgdunix@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
In-Reply-To: <1342606923-9997-1-git-send-email-cywang@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 03:22 AM, Chung-yih Wang wrote:
> The profile sensor clickpad in a Cr-48 Chromebook does a reasonable job of
> tracking individual fingers. This tracking isn't perfect, but, experiments
> show that it works better than just passing "semi-mt" data to userspace,
> and making userspace try to deduce where the fingers are given a bounding box.
>
> This patch tries to report correct two-finger positions instead of the
> {(min_x, min_y), (max_x, max_y)} for profile sensor clickpads on Cr-48
> chromebooks. Note that this device's firmware always reports the higher
> (smaller y) finger in the "sgm" packet, and the lower (larger y) finger in the
> "agm" packet. Thus, when a new finger arrives on the pad, the kernel driver
> uses a simple Euclidean distance measure to deduce which of the two new fingers
> should keep the tracking ID of the previous single finger. Similarly, when one
> finger is removed, the same measure is used to determine which finger remained
> on the pad.

Can it keep track of the touches as you rotate them past each other in 
both the X and Y axes? If not, then it should remain a semi-mt device. 
Even if you can guess which touch is which when a second touch is added, 
you will lose track of it when the user attempts to perform a rotation.

Semi-mt is our only mechanism for telling userspace that the device 
can't accurately tell us about rotations. We could create a new device 
property to say: "This device kinda sorta tells us enough info usually 
to know where two touches are initially." I don't think the effort is 
worth it though. What is the point of providing the exact locations on a 
trackpad if they can't be used for rotation?

-- Chase
