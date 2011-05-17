Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab1EQWui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:50:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48351 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab1EQWuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:50:37 -0400
Date: Tue, 17 May 2011 23:50:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] ftrace: recordmcount: avoid STT_FUNC symbols as base
	on ARM
Message-ID: <20110517225020.GD2266@n2100.arm.linux.org.uk>
References: <1305134631-31617-1-git-send-email-rabin@rab.in> <1305648629.5456.744.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305648629.5456.744.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 12:10:29PM -0400, Steven Rostedt wrote:
> On Wed, 2011-05-11 at 22:53 +0530, Rabin Vincent wrote:
> > While find_secsym_ndx often finds the unamed local STT_SECTION, if a
> > section has only one function in it, the ARM toolchain generates the
> > STT_FUNC symbol before the STT_SECTION, and recordmcount finds this
> > instead.
> > 
> > This is problematic on ARM because in ARM ELFs, "if a [STT_FUNC] symbol
> > addresses a Thumb instruction, its value is the address of the
> > instruction with bit zero set (in a relocatable object, the section
> > offset with bit zero set)".  This leads to incorrect mcount addresses
> > being recorded.
> > 
> > Fix this by not using STT_FUNC symbols as the base on ARM.
> 
> Hi Russell,
> 
> Can you give me an Acked-by on this patch?

It would be better for someone who knows the ELF format for ARM and
its weirdnesses to ack this patch.  I'm afraid my ARM ELF format
knowledge was been superseded when EABI came along and introduced
all sorts of new stuff.
