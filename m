Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2BSUej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:34:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2BSUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:34:38 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v34b3tIZfGoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=9bAiR_rXrmpoHhnyc8gA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to
 determine nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com>
References: <1329617173.1561.5.camel@acer.local.home>
	 <20120219125601.GD25900@elte.hu>
	 <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Feb 2012 15:34:39 -0500
Message-ID: <1329683679.1561.20.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 05:46 -0800, hpanvin@gmail.com wrote:
> Vsyscall page, not vdso...
> 

Peter,

My original patch was to check the %cs register against __KERNEL_CS, but
IIRC, you said that userspace can change that register to anything it
wanted before doing a long jump or something. Is this true for x86_64 as
well? I guess it would be because x86_64 can support 32bit apps.

Anyway, I'll add a check that makes sure that the RIP is less than the
FIXADDR sections as well.

-- Steve


