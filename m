Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0LSIEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 03:04:37 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36658 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0LSIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 03:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cnB/kQErCZFzAytDNK1hxl3uLCbf82pZSOdsk1uooUuBaFlbpVTuzq+SJC99VQAFK1
         O/Xi2sfMP1lT+joxxuMB4z8YvUXuoc1f2Deb32TeDWONgNixCUw0Uuz0I6t6ZrOsHda5
         W7gm2KBCdxXjFMl53edWFphueLwjA6v6GU8R0=
Date: Sun, 19 Dec 2010 00:04:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Input: Fix double equality sign in uevent
Message-ID: <20101219080427.GA10074@core.coreip.homeip.net>
References: <1292700717-1610-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292700717-1610-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 08:31:57PM +0100, Henrik Rydberg wrote:
> Looking at the uevent stream for input devices, all properties
> are on the form "A=B" except the bitmap values, which are on the
> form "A==B". Remedied with this patch.
> 
> Cc: stable@kernel.org
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry,
> 
> Unless the input bitmap properties should really behave differently,
> this patch ought to be a candidate for 2.6.37.
> 

Hmm, I do not think so because:

- either nobody uses bitmap variables and then it is not priority
- users worked around the problem and by applying fix we'd be
  breaking their setups.

I think we should apply it but at the beginning of .38 cycle to give us
a chance to evaluate and maybe revert.

Does this make sense?

-- 
Dmitry
