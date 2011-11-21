Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1KUG35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:29:57 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38381 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1KUG34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:29:56 -0500
MIME-Version: 1.0
In-Reply-To: <87ipme9i9o.fsf@rustcorp.com.au>
References: <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
	<63fcc782681c8b3bd330164871ad4785@localhost>
	<87ipme9i9o.fsf@rustcorp.com.au>
Date: Sun, 20 Nov 2011 22:29:55 -0800
Message-ID: <CAJiQ=7CEg0g=By1bKab9A8n6yLqYVKKhAB0TRRczjU9M6vk=xg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on modules with
 large symbol tables
From: Kevin Cernekee <cernekee@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <JBeulich@suse.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 9:06 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 17 Nov 2011 19:15:02 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
> I'm deeply tempted.  It's very simple, 46 lines shorter, preserves exact
> matches, and doesn't have any strange slowdowns on corner cases.

Unfortunately, the last patch I posted still makes duplicate copies of
the exact matches.  And the copy of nvidia.ko I'm looking at right now
does reuse strtab entries for the duplicated symbols.

FWIW, preserving exact matches would save about 35KB on a kernel
module whose .text + .data + .rodata sections add up to ~9.5MB.

I'm sure there are more clever ways to do it, but a fast brute force
approach could involve storing the core_strtab offsets in a temporary
array indexed by the original strtab st_name values.
