Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab1EZSdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:33:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab1EZSdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=APXKin1hz5vjlunO16I6/mHKeHy13oA0hXHbqMHzfCMElf8Dlq8q8SJ1gCz14MBD3Q
         i2t4cPaFYLFfB0Anw09w==
MIME-Version: 1.0
In-Reply-To: <1306434228.3857.5.camel@gandalf.stny.rr.com>
References: <1304106356-11277-1-git-send-email-vnagarnaik@google.com>
 <1304118968-6620-1-git-send-email-vnagarnaik@google.com> <1306380591.1465.140.camel@gandalf.stny.rr.com>
 <BANLkTin+WYW6Eahgn+yw2eTX44Erc5yBMg@mail.gmail.com> <1306434228.3857.5.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 26 May 2011 11:33:19 -0700
Message-ID: <BANLkTinSGRW7YVrx06fOSGGVh=W-NcPSfg@mail.gmail.com>
Subject: Re: [PATCH] trace: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:23 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-05-26 at 11:00 -0700, Vaibhav Nagarnaik wrote:
>> On Wed, May 25, 2011 at 8:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> >
>> > What you should do is just check if ret is less than zero here.
>> >
>> >        if (ret < 0)
>> >                ret = -ENOMEM;
>>
>> Instead, I don't have to check/set the return value. I can just return
>> "ret" to the caller.
>
> Actually, ret could be -1, if we end up with a miss match in global vs
> max buffers. But that is more of an anomaly. Maybe the solution there is
> to have that return -ENOMEM as well?

Sure, I missed that. Corrected patch coming up!


>
> -- Steve
>
>
>

Vaibhav Nagarnaik
