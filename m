Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1KGTuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:50:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1KGTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:50:35 -0500
Message-ID: <4EB83674.3040207@zytor.com>
Date: Mon, 07 Nov 2011 11:50:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu> <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com> <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
In-Reply-To: <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 11:48 AM, Eric Paris wrote:
> On Mon, Nov 7, 2011 at 2:29 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> On Mon, Nov 07, 2011 at 11:18 -0800, H. Peter Anvin wrote:
> 
>> As to procfs, I see no real need of adding mode/group mount option for
>> global procfs files (/proc/interrupts, /proc/stat, etc.) - it can be
>> done by distro specific init scripts (chown+chmod).  I don't mind
>> against such an option for the convenience, though.
> 
> While possible, the chmod+chown 'solutions' just aren't as simple as
> you pretend.  Every time one creates a chroot environment and mounts
> /proc it has be manually fixed there as well.  Same thing with a
> container.  Sure if /proc were something that was only ever mounted
> one time on a box it wouldn't be so bad, but that's not the case.....

Yes, for a filesystem that dynamically creates nodes, a static script
just doesn't work well.  Control options do, like we have for devpts for
example.

	-hpa

