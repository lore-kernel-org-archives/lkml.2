Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0CZX3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:29:50 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:38748 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752558Ab0CZX3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:29:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=BZ5y3qtzenBCNRyNDU8TGwyXzHkL/RkFI4puCw1sbAnKn31/SdJA6EB2/vLSIsThzbY4Sx1Nze6TjJbXCxJREb6QddSRKd2elqIy6z7PVcbmbVahMB5wePOvDX56PVQR;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC] Intelligent power sharing driver
Date: Fri, 26 Mar 2010 16:29:04 -0700
Message-Id: <1269646146-13296-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.6.3.3
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the core IPS driver to drivers/platform/x86, along with
some helper code in the timer subsystem to allow for deferrable on-stack
timers.

Note that the deferrable timers don't actually work at this point; I'm
probably just doing something silly in the IPS driver in using them, but
it's possible the core code is wrong too, I'm hoping for some review
there (so testing thus far has been with a fixed sample rate).

Also note that this patchset doesn't include the i915 specific bits for
monitoring power consumption; I'm still debugging those (my current
platform overreports power by several watts; I'm hoping a production
platform will return reasonable values) but expect to be able to post
them soon.  With the combination of this driver and the i915 code, I
expect significant GPU performance gains; early measurements with simple
loads show about a 15% improvement, but I've heard reports of even
higher.

Anyway, please take a look and let me know what needs fixing or how I
might make this a better driver.

Thanks,
Jesse

