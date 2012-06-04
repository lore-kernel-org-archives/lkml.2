Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2FDJfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:35:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2FDJfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:35:53 -0400
Message-ID: <1338802545.28282.11.camel@twins>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jun 2012 11:35:45 +0200
In-Reply-To: <20120604002030.GT30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
	 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120604000059.GA14144@redhat.com>
	 <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
	 <20120604002030.GT30000@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 01:20 +0100, Al Viro wrote:
> 
> Another question re lockdep - does it scream loudly if process returns
> to userland without having released some lock?  I hope so, but I've never
> checked that... ;-/ 

It does, on some archs. git grep lockdep_sys_exit, suggests x86 and
s390.

http://www.google.com/search?q=lock+held+when+returning+to+user+space

will find you people who tripped it ;-) There's a few filesystems that
did various vile things on freeze or so.
