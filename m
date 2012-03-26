Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab2CZSp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:45:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2CZSp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:45:28 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wBLf1-ka6lYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=57neN2dlDuRsF5ViA4oA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1332597305.12799.2.camel@acer.local.home>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	 <1332531400.23924.71.camel@gandalf.stny.rr.com>
	 <CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
	 <1332597305.12799.2.camel@acer.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 13:45:32 -0400
Message-ID: <1332783932.12799.16.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 09:55 -0400, Steven Rostedt wrote:

> That said, I may consider taking the patch, as another way of resetting
> the tracer. I have to see what workflows it will affect first.

This is what I was afraid of. The tracers irqsoff and preemptoff do not
get reset if you echo the tracer name into the current_tracer. This
makes different tracers inconsistent.

All tracers must act the same. So, it's a no go for this patch, at least
in its current form.

-- Steve


