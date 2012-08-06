Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2HFKVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:21:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HFKVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:21:17 -0400
Date: Mon, 6 Aug 2012 12:21:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Vasilyev <pavel@pavlinux.ru>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
Message-ID: <20120806102114.GA31404@elf.ucw.cz>
References: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
 <5011F15A.3060007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011F15A.3060007@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2012-07-26 21:39:38, Len Brown wrote:
> ...both give the number of chars in the string
> without the '\0', as strncmp() wants,
> but sizeof() is compile-time.

What about introducing something like streq() to do this
automatically? This is ugly....

#define streq(a, b) ... if (_buildin_constant(b)) ...

?

> -	if (!strncmp(val, "enable", strlen("enable"))) {
> +	if (!strncmp(val, "enable", sizeof("enable") - 1)) {

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
