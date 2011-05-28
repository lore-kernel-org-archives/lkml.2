Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1E1Bu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 21:50:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1E1Buz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 21:50:55 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=RSA36dx1YggM7O0eq88A:9 a=FhI-IxFXLLj3aqfBrQwA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
	 <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
	 <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
	 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 21:50:53 -0400
Message-ID: <1306547453.3857.44.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 17:44 -0700, Vaibhav Nagarnaik wrote:

> That said, I am open to changing it if Steven and you think using
> oom_killer_disabled is a better solution.

My biggest concern is that we are setting policy in the kernel. If you
are concerned about this, why not just have the process that is going to
increase the size of the ring buffer adjust its own oom policy
with /proc/<pid>/oom_score_adj ? Only a privilege process can increase
the size of the ring buffer so it's not like we are worried about any
normal user task upping the ring buffer to kill other processes.

-- Steve


