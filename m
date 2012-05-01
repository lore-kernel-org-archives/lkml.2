Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2EANZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:25:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48827 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2EANZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:25:31 -0400
Date: Tue, 1 May 2012 06:24:09 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/3] vmevent: Implement 'low memory' attribute
Message-ID: <20120501132409.GA22894@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Accounting only free pages is very inaccurate for low memory handling,
so we have to be smarter here.

The patch set implements a new attribute, which is blended from various
memory statistics. Vmevent can't expose all the kernel internals to the
userland, as it would make internal Linux MM representation tied to the
ABI. So the ABI itself was made very simple: just number of pages before
we consider that we're low on memory, and the kernel takes care of the
rest.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
