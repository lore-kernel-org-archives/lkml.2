Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1EEIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:16:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56808 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752353Ab1EEIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:16:55 -0400
Date: Thu, 5 May 2011 09:16:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate regulator sysfs files..
Message-ID: <20110505081633.GC11744@opensource.wolfsonmicro.com>
References: <BANLkTimme-B72D=QfsdgAUKP83VoaKrWNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimme-B72D=QfsdgAUKP83VoaKrWNw@mail.gmail.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:39:11PM -0700, Linus Torvalds wrote:

>  appended is a report from Werner Landgraf <w.landgraf@ru.ru> who
> builds a kernel with pretty much everything enabled, and forwarded
> this from one of his testers.

> Comments? Why does that "supply vmmc not found, using dummy regulator"
> message show up twice? And apparently it tries to register it both
> times, which on the second try results in a WARN_ON() from sysfs..

Yes, this is a bug in the consumer driver - it's requesting the same
supply twice for the same device, causing the regulator API to try to
set the supply up twice.  It should only be requesting it once.  Ideally
the API should reject the second get() but the user is buggy anyway.
