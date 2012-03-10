Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2CJTlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 14:41:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41491 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2CJTlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 14:41:05 -0500
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <CAO9zADykAFW6omxbKfHj-6=srgcAqREqGAOyTqMt4PEEhM06KQ@mail.gmail.com>
References: <CAO9zADykAFW6omxbKfHj-6=srgcAqREqGAOyTqMt4PEEhM06KQ@mail.gmail.com>
Date: Sat, 10 Mar 2012 14:41:03 -0500
Message-ID: <CAO9zADwwu-EEdoEm74bw6T9L1HyuomzJa6w0UTGj734YdVLYew@mail.gmail.com>
Subject: Re: 3.2.0 - page allocation failure: order:[2345] mode:0x20
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 9:38 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> Question:
> Is the below normal or is this a kernel bug?
>
> Specs:
> Kernel: 3.2.0
> Arch: x86_64
> Dist: Debian Testing
>
> Running 3.2.0 on x86_64; generally little to no swap use depending on
> what is running (e.g., chrome)
> top--
> Mem:   7925172k total,  7401552k used,   523620k free,    74472k buffers
> Swap:  2097148k total,     6184k used,  2090964k free,  6384816k cached
>
> Lots of page allocation failures:
> [1434349.602309] sshd: page allocation failure: order:3, mode:0x20
> [1434366.128757] sshd: page allocation failure: order:2, mode:0x20
> [1434371.230589] sshd: page allocation failure: order:2, mode:0x20

Hi,

Update:

Found this..
http://lists.openwall.net/netdev/2011/11/28/25

More testing needed of course but no new page allocation errors (at
least not after 8-10+ hours) after disabling the following:
/sbin/ethtool -K eth0 gro off
/sbin/ethtool -K eth0 tso off

Justin.
