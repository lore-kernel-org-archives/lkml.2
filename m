Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1HZUeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32811 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1HZUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:18 -0400
Date: Fri, 26 Aug 2011 22:34:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 03/36] Hexagon: Add bitops support
Message-ID: <20110826203410.GB6630@ucw.cz>
References: <20110817163457.878854582@codeaurora.org>
 <20110817163520.145693358@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817163520.145693358@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +	__asm__ __volatile__ (
> +	"	{R10 = %1; R11 = asr(%2,#5); }\n"
> +	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
> +	"1:	R12 = memw_locked(R10);\n"
> +	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
> +	"	memw_locked(R10,P1) = R12;\n"
> +	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"

Nice assembly syntax, btw. I can only wish architectures such as arm
used something as readable...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
