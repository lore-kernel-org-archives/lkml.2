Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0K2KPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:15:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48109 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0K2KPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:15:54 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Eric Cooper <ecc@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] add netdev led trigger
References: <1290998056-8310-1-git-send-email-ecc@cmu.edu>
Date: Mon, 29 Nov 2010 11:15:51 +0100
In-Reply-To: <1290998056-8310-1-git-send-email-ecc@cmu.edu> (Eric Cooper's
	message of "Sun, 28 Nov 2010 21:34:16 -0500")
Message-ID: <87ipzgl9k8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Cooper <ecc@cmu.edu> writes:

> Add a netdev LED trigger for all Blinkenlights lovers...
> Originally taken from https://dev.openwrt.org/ticket/2776
> Slightly updated for 2.6.24 by Mickey Lauer <mickey@openmoko.org>
> and for 2.6.36 by Eric Cooper <ecc@cmu.edu>

You should really send this to netdev too.

Some comments:

The timer seems power unfriendly -- it will always tick even if nothing 
happens.

Using the device name as an identifier is not reliable, they may 
not be unique.

rwlocks are deprecated.

your store code has a off by one I think, it's possible to put 
not 0 terminated data in the string.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
