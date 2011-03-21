Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1CUSEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:04:09 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47091 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753235Ab1CUSEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:04:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=E1sAxpfYMNgn/a7PH4VsNhmG3FmcJEZ7tiNnDontuPIK/wwNh7qjvilbFWlSyOdLw3L35dTYy9wqs/i2+5axOnxZW/Jy3Wro3vjKU389OG2Fxjc+Yc1trY+spz/sYoWM;
Date: Mon, 21 Mar 2011 11:04:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
Message-ID: <20110321110404.6a71a404@jbarnes-desktop>
In-Reply-To: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011 16:38:38 +0100
Andreas Hartmann <andihartmann@01019freenet.de> wrote:

> Hello,
> 
> on my MSI CR620 laptop, intel_ips produces a constant load of 1, even if
> the machine is idle.
> 
> The ips-monitor hangs in D state:
> 
> ps aux | grep ips
> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
> [ips-adjust]
> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
> [ips-monitor]
> 
> If the module isn't loaded, the load of the machine in idle mode is 0 as
> expected.

This is a reporting problem, and probably due to the schedule() call
and associated task state in the ips-monitor thread.  I thought setting
the task state to interruptible would prevent this, but it seems like
it's not enough for the deferrable on-stack timers?

At any rate, it's not actually causing increased CPU usage, so you can
safely ignore it until we have a fix.

-- 
Jesse Barnes, Intel Open Source Technology Center
