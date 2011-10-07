Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464Ab1JGLut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:50:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43981 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965401Ab1JGLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:50:48 -0400
Date: Fri, 7 Oct 2011 12:50:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Long stalls during boot with -next
Message-ID: <20111007115047.GC24534@sirena.org.uk>
References: <20110929125035.GA2085@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929125035.GA2085@sirena.org.uk>
X-Cookie: Identify your visitor.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 01:50:36PM +0100, Mark Brown wrote:
> Since Tuesday I've been experiencing stalls on boot with -next kernels.
> The boot appears to proceed normally but there appears to be a good ten
> second delay somewhere around the late_initcall() stage with no
> indication in the logs:

I identified the problem here, the behaviour of LL_DEBUG was changed to
make it select DEBUG_ICEDCC by default which is unfortunate if one
doesn't have an EmbeddedICE connected.
