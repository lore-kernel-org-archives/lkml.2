Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1ERA1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:27:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1ERA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:27:18 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=uB6k01T4ArMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QmAn9pWrrmH5xC_ZU_YA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: recordmcount: avoid STT_FUNC symbols as base
 on ARM
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>
In-Reply-To: <20110517225020.GD2266@n2100.arm.linux.org.uk>
References: <1305134631-31617-1-git-send-email-rabin@rab.in>
	 <1305648629.5456.744.camel@gandalf.stny.rr.com>
	 <20110517225020.GD2266@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 20:27:15 -0400
Message-ID: <1305678435.26849.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:50 +0100, Russell King - ARM Linux wrote:
> On Tue, May 17, 2011 at 12:10:29PM -0400, Steven Rostedt wrote:
> > On Wed, 2011-05-11 at 22:53 +0530, Rabin Vincent wrote:
> > > While find_secsym_ndx often finds the unamed local STT_SECTION, if a
> > > section has only one function in it, the ARM toolchain generates the
> > > STT_FUNC symbol before the STT_SECTION, and recordmcount finds this
> > > instead.
> > > 
> > > This is problematic on ARM because in ARM ELFs, "if a [STT_FUNC] symbol
> > > addresses a Thumb instruction, its value is the address of the
> > > instruction with bit zero set (in a relocatable object, the section
> > > offset with bit zero set)".  This leads to incorrect mcount addresses
> > > being recorded.
> > > 
> > > Fix this by not using STT_FUNC symbols as the base on ARM.
> > 
> > Hi Russell,
> > 
> > Can you give me an Acked-by on this patch?
> 
> It would be better for someone who knows the ELF format for ARM and
> its weirdnesses to ack this patch.  I'm afraid my ARM ELF format
> knowledge was been superseded when EABI came along and introduced
> all sorts of new stuff.

OK, in that case, I'll just apply the patch.

Thanks!

-- Steve


