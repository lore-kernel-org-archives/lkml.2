Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0LMCuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:50:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62003 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0LMCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:50:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NyVNpACkBs357yEOC8RLZasB+Y3mqcqRbFPk+oNwSsnI+qDT7+uNFe13WNfSL/u3Co
         0KLcomZauy/EXq6TnTYazdU/sVMnDLh6pRRQp1OWtsUuVle/Io+i1NZDTmEm0z+1WEzS
         nOH2QDVYHkgf8VQNjVquhhhWSjUdmOWnpScm4=
Date: Sun, 12 Dec 2010 18:50:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] input: mt: Add button support for five fingers
Message-ID: <20101213025016.GC21401@core.coreip.homeip.net>
References: <1292063308-15327-1-git-send-email-rydberg@euromail.se>
 <1292063308-15327-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292063308-15327-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 11:28:28AM +0100, Henrik Rydberg wrote:
> This patch adds BTN_TOOL_QUINTAP to be used by hardware reporting
> finger counts different from the number of MT contacts.

I must say this is quite ugly, but so is introducing ABS_CONTACT_COUNT
or similar, except that the latter is more extensible so if
manufacturers decide to report 6, 7, 8 fingers (but not their
coordinates) we won't have to breed BTN_TOOL_xxxTAPs...

But let me ask you this: do we know what to do with 5 fingers? How do we
plan to react to such gestures? Maybe the best option is simply ignore
it and don't report anything if there are no userspace consumers?

Thanks.

-- 
Dmitry
