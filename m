Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2DHXgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:36:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64924 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2DHXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:36:14 -0400
Date: Mon, 9 Apr 2012 03:36:05 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 0/3] vmevent: Some fixes + a new event type
Message-ID: <20120408233550.GA3791@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This small patch set fixes a bug in the vmevent core, plus makes the
vmevent-test buildable w/o unneded SDL library.

Plus, we add a new 'cross' event type: the event will trigger whenever
a value crosses a user-specified threshold. It works two-way, i.e. when
a value crosses the threshold from a lesser values side to a greater 
values side, and vice versa.

We use the event type in an userspace low-memory killer: we get a
notification when memory becomes low, so we start freeing memory by
killing unneeded processes, and we get notification when memory hits
the threshold from another side, so we know that we freed enough of
memory.

The patches are against

	git://github.com/penberg/linux.git vmevent/core

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
