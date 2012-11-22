Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab2KVT4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:56:12 -0500
Received: from brockman.in8.de ([85.214.220.56]:59095 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965248Ab2KVT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:56:07 -0500
Message-ID: <50AE26AE.20704@jan-o-sch.net>
Date: Thu, 22 Nov 2012 14:20:46 +0100
From: Jan Schmidt <list.lkml@jan-o-sch.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /proc/kmsg giving eof on blocking read
References: <50AE0210.7010301@jan-o-sch.net> <CAPXgP13OyV-hT=D_-rOyuk2_4n1deQ57ZdRvooBS5Z=sHM_HuQ@mail.gmail.com>
In-Reply-To: <CAPXgP13OyV-hT=D_-rOyuk2_4n1deQ57ZdRvooBS5Z=sHM_HuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, November 22, 2012 at 13:29 (+0100), Kay Sievers wrote:
> On Thu, Nov 22, 2012 at 11:44 AM, Jan Schmidt <list.lkml@jan-o-sch.net> wrote:
>> I'm currently debugging something in btrfs in good old printk style, generating
>> around 10MB/min. I'm seeing /proc/kmsg returning eof on a blocking read (and,
>> side note, syslog-ng won't reopen it, effectively stopping logging kernel
>> messages silently).
> 
> Are you sure there is not something else that opens the same file?

Those errors didn't happen on that machine ever before, and there should have
been no user land changes to it for quite a long time.

I'm tempted to say there is no other kmsg reader, but just to make it entirely
sure, how would I trace this? From a quick look at ftrace I don't see it would
output file names when tracing sys_open, unfortunately.

Thanks!
-Jan
