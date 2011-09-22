Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1IVIL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:11:27 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:42687 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1IVILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:11:25 -0400
X-Greylist: delayed 2589 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 04:11:25 EDT
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
From: "Jon Medhurst (Tixy)" <jon.medhurst@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>, Laura Abbott <lauraa@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110921115553.GF17169@n2100.arm.linux.org.uk>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
	 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
	 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
	 <20110921113906.GB2872@arm.com>
	 <20110921115553.GF17169@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 08:28:08 +0100
Message-ID: <1316676488.2053.9.camel@linaro1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 12:55 +0100, Russell King - ARM Linux wrote:
> Instructions such as VFP, kprobes tracing, etc are expected fault
> locations, and those are fairly well controlled where they can be placed.
> With things like ftrace, it certainly is the case that the unwinder can
> theoretically be called from almost anywhere in a function.

Actually, kprobes can be places on any instruction in the kernel that
isn't in the section .kprobes.text.

I also strongly suspect that stack unwinding won't happen correctly
across the boundary between the kprobes handling code and the function
which was probed - there's an awful lot of stack jiggery pokery going on
there.

-- 
Tixy

