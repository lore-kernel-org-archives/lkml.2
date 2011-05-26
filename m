Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1EZSXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:23:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1EZSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:23:50 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vVy0PQ3ZQx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=76pVKIetd4Xcx1ojzN4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add a free on close control mechanism for
 buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <BANLkTin+WYW6Eahgn+yw2eTX44Erc5yBMg@mail.gmail.com>
References: <1304106356-11277-1-git-send-email-vnagarnaik@google.com>
	 <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
	 <1306380591.1465.140.camel@gandalf.stny.rr.com>
	 <BANLkTin+WYW6Eahgn+yw2eTX44Erc5yBMg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 14:23:48 -0400
Message-ID: <1306434228.3857.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 11:00 -0700, Vaibhav Nagarnaik wrote:
> On Wed, May 25, 2011 at 8:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> >
> > What you should do is just check if ret is less than zero here.
> >
> >        if (ret < 0)
> >                ret = -ENOMEM;
> 
> Instead, I don't have to check/set the return value. I can just return
> "ret" to the caller.

Actually, ret could be -1, if we end up with a miss match in global vs
max buffers. But that is more of an anomaly. Maybe the solution there is
to have that return -ENOMEM as well?

-- Steve


