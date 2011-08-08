Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HHKwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:52:08 -0400
Received: from science.horizon.com ([71.41.210.146]:10977 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750823Ab1HHKwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:52:04 -0400
Date: 8 Aug 2011 06:52:01 -0400
Message-ID: <20110808105201.25396.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joakim.tjernlund@transmode.se, linux@horizon.com
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
In-Reply-To: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I prefer to keep the current code which (at the time) generated good code
> for at least ppc:
> 	/* Align it */
> 	if (unlikely((long)buf & 3 && len)) {
> 		do {
> 			DO_CRC(*buf++);
> 		} while ((--len) && ((long)buf)&3);
> 	}

Ah, I was looking at fzago's initial patch; I hadn't realized you'd
tweaked it.  That's pretty much what I was talking about.

Would
 	if (unlikely((long)buf & 3) && len) {

give the compiler better hints?  len != 0 is awfully
likely, actually.
