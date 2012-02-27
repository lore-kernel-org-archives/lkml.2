Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2B0W15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:27:57 -0500
Received: from lulu.zabbo.net ([69.168.54.52]:43125 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2B0W14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:27:56 -0500
Message-ID: <4F4C036A.2080808@zabbo.net>
Date: Mon, 27 Feb 2012 17:27:54 -0500
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 04:19 PM, Dave Kleikamp wrote:
> This patchset was begun by Zach Brown and was originally submitted for
> review in October, 2009.

Man, it's been a while.  I remembered almost none of the details of this
work when I read your introductory message.  As I read the patches it
all came flooding back, though.  Yikes :).

My biggest fear about this patch series is the sheer amount of very
fiddly code motion.  I remember spending a lot of time verifying that
the patches didn't accidentally lose new changes as the patches were
ported to newer kernels.

Has someone gone through these most recent patches with an absurdly fine
toothed comb?  The patches that touch fs/direct-io.c and mm/filemap.c
are the most risky, by far.

> This series was written to reduce the current overhead loop imposes by
> performing synchronus buffered file system IO from a kernel thread.  These
> patches turn loop into a light weight layer that translates bios into iocbs.

It'd be worth including some simple benchmark results, I think.  I
remember testing with concurrent O_DIRECT aio with fio on a loopback
device on top of files in each underlying file system.

- z
