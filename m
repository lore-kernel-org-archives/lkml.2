Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab2BCU6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:58:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab2BCU5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:57:24 -0500
Date: Fri, 3 Feb 2012 12:57:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
Message-Id: <20120203125715.0e9dfb1d.akpm@linux-foundation.org>
In-Reply-To: <20120203100743.GA3334@elte.hu>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.309402052@openvz.org>
	<20120203074656.GC30543@elte.hu>
	<20120203083530.GD1968@moon>
	<20120203090929.GA23996@elte.hu>
	<20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	<20120203095227.GA13162@elte.hu>
	<20120203100743.GA3334@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012 11:07:43 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> [PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums
> 
> The overwhelming majority of kernel developers have stopped 
> using 80 col terminals years ago.
> 
> As far as I'm aware I was the last regular kernel contributor 
> who still used a standard VGA text console, but both text 
> consoles and using them to read the kernel source code has 
> become increasingly gruesome years ago so I switched to a wider 
> terminal two years ago.

I always use 80-cols, everywhere.  Not because I particularly like it -
I find it a bit too small.  I use it because it is the standard, and
using it helps me see where and how badly we violate the standard.

We've actually done pretty well - linewrap in 80 cols rarely causes me
problems.  It's sufficiently rare that when it *does* happen, it really
stands out.

IOW, the changelog is quite the exaggeration.

> So lets increase the limit to 100 cols

I think that's going too far - 96 will be enough and it's a multiple of 8.

The multiple-of-8 thing seems pleasing but probably doesn't matter
much.  It means that things like


if (foo) {
	if (foo) {
		if (foo) {
			if (foo) {
				if (foo) {
					if (foo) {
						if (foo) {
							if (foo) {
								if (foo) {
									if (foo) {
										if (foo) {
											if (foo) {
												if (foo) {
													if (foo) {
														if (foo) {
												

will line up properly.


If we really want to improve the world we should jump into a time
machine and set tabstops to 4.  Sigh.

