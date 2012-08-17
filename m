Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2HQOhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab2HQOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:36:54 -0400
Date: Fri, 17 Aug 2012 11:36:44 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Worsley <amworsley@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Roland Ramthun <mail@roland-ramthun.de>
Subject: Re: [v2.6.34-stable 137/165] USB: Fix Corruption issue in USB ftdi
 driver ftdi_sio.c
Message-ID: <20120817143642.GA4039@herton-Z68MA-D2H-B3>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
 <1345060109-9187-138-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345060109-9187-138-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:48:01PM -0400, Paul Gortmaker wrote:
> From: Andrew Worsley <amworsley@gmail.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit b1ffb4c851f185e9051ba837c16d9b84ef688d26 upstream.
> 
> Fix for ftdi_set_termios() glitching output
> 
> ftdi_set_termios() is constantly setting the baud rate, data bits and parity
> unnecessarily on every call, . When called while characters are being
> transmitted can cause the FTDI chip to corrupt the serial port bit stream
> output by stalling the output half a bit during the output of a character.
> Simple fix by skipping this setting if the baud rate/data bits/parity are
> unchanged.
> 
> Signed-off-by: Andrew Worsley <amworsley@gmail.com>
[...]

commit 108e02b12921078a59dcacd048079ece48a4a983 ("USB: ftdi_sio: fix
initial baud rate") says it addresses a regression on this change,
something to consider for inclusion with this update.

-- 
[]'s
Herton
