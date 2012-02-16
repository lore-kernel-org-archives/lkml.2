Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2BPK06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab2BPK0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:26:55 -0500
Message-ID: <4F3CD9D9.2050900@redhat.com>
Date: Thu, 16 Feb 2012 12:26:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: qemu-devel@nongnu.org, Alexander Graf <agraf@suse.de>,
        michael@ellerman.id.au, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <1328597934.6802.6.camel@concordia> <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de> <201202152221.36154.arnd@arndb.de>
In-Reply-To: <201202152221.36154.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 12:21 AM, Arnd Bergmann wrote:
> ioctl is good for hardware devices and stuff that you want to enumerate
> and/or control permissions on. For something like KVM that is really a
> core kernel service, a syscall makes much more sense.
>
> I would certainly never mix the two concepts: If you use a chardev to get
> a file descriptor, use ioctl to do operations on it, and if you use a 
> syscall to get the file descriptor then use other syscalls to do operations
> on it.
>
> I don't really have a good recommendation whether or not to change from an
> ioctl based interface to syscall for KVM now. On the one hand I believe it
> would be significantly cleaner, on the other hand we cannot remove the
> chardev interface any more since there are many existing users.
>

This sums up my feelings exactly.  Moving to syscalls would be an
improvement, but not so much an improvement as to warrant the thrashing
and the pain from having to maintain the old interface for a long while.

-- 
error compiling committee.c: too many arguments to function

