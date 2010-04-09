Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0DIWKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:10:48 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:33162 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751035Ab0DIWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:10:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L/AZDU4JmwPT3a/GynzXfFdJh8L7lTEHBsuybFSKvNs0MGEQhj0RXtpTmqKcPvpyArFgR2dJ/eyjQIMUmQaowCot8E1bf6Wi2mIfRJariRhetjo//NYF/A+nVXAkzEuE;
Date: Fri, 9 Apr 2010 15:10:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: [RFC] Try a bit harder to get output on the screen at panic time
Message-ID: <20100409151050.74ef6dcd@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of 3 patches makes it a little more likely we'll get panic
output onto the screen even when X is running, assuming a KMS enabled
stack anyway.

It gets me from a blank or very sparsely populated black screen at
panic time, to one including the full backtrace and panic output at
panic time (tested with "echo c > /proc/sysrq-trigger" from an X
session).

It doesn't cover every case; for instance I think it'll fail when X has
disabled the display, but those cases need to be handled with separate
patches anyway (need to add atomic DPMS paths for instance).

Anyway, please test these out and let me know if they work for you.

-- 
Jesse Barnes, Intel Open Source Technology Center
