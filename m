Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1D1DYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:24:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49035 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1D1DYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110428122334.D197.A69D9226@jp.fujitsu.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-3-git-send-email-wad@chromium.org>
	<20110428122334.D197.A69D9226@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 22:24:20 -0500
Message-ID: <BANLkTinfXZ3j0vG51=cQjM0FZQ5VR5ze8A@mail.gmail.com>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
From: Will Drewry <wad@chromium.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:21 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Adds seccomp and seccomp_filter status reporting to proc.
>> /proc/<pid>/status will include a Seccomp field, and
>> /proc/<pid>/seccomp_filter will provide read-only access
>> to the current filter and bitmask set for seccomp_filters.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  fs/proc/array.c |   21 +++++++++++++++++++++
>>  fs/proc/base.c  |   25 +++++++++++++++++++++++++
>>  2 files changed, 46 insertions(+), 0 deletions(-)
>
> I'm not againt seccomp_filter. but I dislike to increase /proc/<pid>/status mess.
> 1) it's read from a lot of applications, I don't want to worry about performance
> thing. 2) 99.99% user never use seccomp. this field is useless for them.
>
> Can't you make individual seccomp specific file?

Definitely.  Would it make sense to have /proc/<pid>/seccomp and
/proc/<pid>/seccomp_filter?
