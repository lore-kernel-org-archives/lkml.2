Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2GXLT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 07:19:57 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60980 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2GXLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 07:19:56 -0400
X-Greylist: delayed 31365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 07:19:56 EDT
X-AuditID: b753bd60-940f3ba000004f2e-98-500e84d9ddce
X-AuditID: b753bd60-940f3ba000004f2e-98-500e84d9ddce
Message-ID: <500E84D7.7060103@hitachi.com>
Date: Tue, 24 Jul 2012 20:19:51 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <CAJSP0QW_2JJ0nf=NW0y30VSid2HSxaqb=mRGV8CTtAKj0ujDWw@mail.gmail.com> <500E810A.4030309@hitachi.com>
In-Reply-To: <500E810A.4030309@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Thank you for commenting on our patch set.

(2012/07/24 20:03), Masami Hiramatsu wrote:
> (2012/07/24 19:02), Stefan Hajnoczi wrote:
>> On Tue, Jul 24, 2012 at 3:36 AM, Yoshihiro YUNOMAE
>> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>> The performance of each method is compared as follows:
>>>   [1] Native
>>>       - only recording trace data to ring-buffer on a guest
>>>   [2] Virtio-trace
>>>       - running a trace agent on a guest
>>>       - a reader on a host opens FIFO using cat command
>>>   [3] IVRing
>>>       - A SystemTap script in a guest records trace data to IVRing.
>>>         -- probe points are same as ftrace.
>>>   [4] Virtio-serial(normal)
>>>       - A reader(using cat) on a guest output trace data to a host using
>>>         standard output via virtio-serial.
>>
>> The first time I read this I thought you are adding a new virtio-trace
>> device.  But it looks like this series really add splice support to
>> virtio-console and that yields a big performance improvement when
>> sending trace_pipe_raw.
>
> Yes, sorry for the confusion. Actually this is an enhancement of
> virtio-serial. I'm working with Yoshihiro on this feature.
>
>> Guest ftrace is useful and I like this.  Have you thought about
>> controlling ftrace from the host?  Perhaps a command could be added to
>> the QEMU guest agent which basically invokes trace-cmd/perf.
>
> As you can see, guest trace-agent can be controlled via a
> control channel. In our scenario, host tools can control that
> instead of guest one.
>
> We are considering that exporting the tracing part of guest's
> debugfs to host via another virtio-serial channel by using
> 9pfs, so that the host tools can refer that.
>
> (In this scenario, guest trace-agent will also provide 9pfs server.
> Since it means that the agent can handle writing a special file,
> trace-agent can be controlled via the special file on exported
> debugfs.)
>
> Of course, this also requires modifying trace-cmd/perf to accept
> some options like guest-debugfs mount point, guest's serial
> channel pipe (or unix socket?), etc. However, it will be a small
> change.
>
> Thank you,
>

 >> Are you using text formatted ftrace?
No, currently using raw format, but　we'd like to reformat it in text.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


