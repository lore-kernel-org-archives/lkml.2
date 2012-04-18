Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2DRId0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:33:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38680 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2DRIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:33:23 -0400
Date: Wed, 18 Apr 2012 01:32:08 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH v2 0/2] vmevent: Greater-than attribute + one-shot mode + a
 bugfix
Message-ID: <20120418083208.GA24904@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

That's a respin of the previous patchset that tried to add a new
'cross' event type, which would trigger whenever value crosses a
user-specified threshold both ways, i.e. from a lesser values side
to a greater values side, and vice versa.

We use the event type in an userspace low-memory killer: we get a
notification when memory becomes low, so we start freeing memory by
killing unneeded processes, and we get notification when memory hits
the threshold from another side, so we know that we freed enough of
memory.

There's also a fix for a bug that makes kernel upset about sleeping
in the atomic context.

Per Pekka's comments here comes v2. Changes:

- Added a one-shot mode plus a greater-than attribute, the two
  additions makes the equivalent of the cross-event type.
- In the bugfix patch I added some comments about implementation
  details of the lock-free logic. Also, in the previous version of
  the fix I forgot to remove 'struct mutex' form the
  'struct vmevent_watch', this is now cleaned up.

As usual, the patches are against

	git://github.com/penberg/linux.git vmevent/core

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
