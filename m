Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2DDXji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:39:38 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:20285 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2DDXjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:39:37 -0400
Message-ID: <4F7CDBB6.3000106@tilera.com>
Date: Wed, 4 Apr 2012 19:39:34 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        <serge.hallyn@canonical.com>, <criu@openvz.org>,
        <lucas.demarchi@profusion.mobi>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] IPC: message queue receive cleanup
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6> <20120215165431.27978.36457.stgit@localhost6.localdomain6> <20120404160544.f60c2150.akpm@linux-foundation.org>
In-Reply-To: <20120404160544.f60c2150.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2012 7:05 PM, Andrew Morton wrote:
> On Wed, 15 Feb 2012 20:54:31 +0400
> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
>
>> This patch moves all message related manipulation into one function msg_fill().
>> Actually, two functions because of the compat one.
>>
>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>>
>> ---
>>  arch/tile/kernel/compat.c |   11 +----------
>>  include/linux/compat.h    |    2 ++
>>  include/linux/msg.h       |    5 +++--
>>  ipc/compat.c              |   33 +++++++++++++++++----------------
>>  ipc/msg.c                 |   44 +++++++++++++++++++++++---------------------
> The arch/tile/kernel/compat.c change throws a big reject against
> current mainline because the code it is patching has disappeared and I
> didn't check where it went.  Check this, please?

I merged that code into ipc/compat.c with a new
CONFIG_ARCH_WANT_OLD_COMPAT_IPC guard in commit 48b25c43e6ee.

> Arnd, could you please pass an eye across this work?  Thanks.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

