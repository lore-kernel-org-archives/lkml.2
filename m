Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670Ab2EIRyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:54:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487Ab2EIRyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:54:20 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0in4RCm__d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=f5rXRSdyhcyBeFY_lAoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336586058.14207.211.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 13:54:18 -0400
In-Reply-To: <CAL26m8KdY3KYO6_TEsuZxQUC6nn3tFzt8y7f6zBymM-pYHZtYw@mail.gmail.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
	 <1336534682.14207.197.camel@gandalf.stny.rr.com>
	 <CAL26m8J9j9oqGRte80Kp7zH8DQr5RuHPS88w7+2hry2E-N7VYg@mail.gmail.com>
	 <1336573788.14207.208.camel@gandalf.stny.rr.com>
	 <CAL26m8KdY3KYO6_TEsuZxQUC6nn3tFzt8y7f6zBymM-pYHZtYw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:46 -0700, Vaibhav Nagarnaik wrote:
> On Wed, May 9, 2012 at 7:29 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > This is far from a hot path. In fact, it's quite slow. Lets not uglify
> > code just to optimize something that's not time critical.
> >
> > Please combine these two into a single loop. The wait for completion is
> > fine as a separate loop.
> >
> 
> Sure, I will update the patch with that change. Have you found any
> other issues in testing the patch?
> 

Nope, not yet. Sorry for the spotty checks, I'm doing several other
things in between.

-- Steve


