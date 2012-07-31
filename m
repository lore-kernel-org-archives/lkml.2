Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2GaAwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 20:52:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46994 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2GaAwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 20:52:35 -0400
X-AuditID: b753bd60-a0885ba000000655-a3-50172c4f4ca5
X-AuditID: b753bd60-a0885ba000000655-a3-50172c4f4ca5
Message-ID: <50172C4E.7090202@hitachi.com>
Date: Tue, 31 Jul 2012 09:52:30 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
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
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <20120726113537.GH9473@amit.redhat.com> <5012576F.7040500@hitachi.com> <20120727094320.GK18651@amit.redhat.com>
In-Reply-To: <20120727094320.GK18651@amit.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Sorry for the late reply.

(2012/07/27 18:43), Amit Shah wrote:
> On (Fri) 27 Jul 2012 [17:55:11], Yoshihiro YUNOMAE wrote:
>> Hi Amit,
>>
>> Thank you for commenting on our work.
>>
>> (2012/07/26 20:35), Amit Shah wrote:
>>> On (Tue) 24 Jul 2012 [11:36:57], Yoshihiro YUNOMAE wrote:
>>

[...]

>>>>
>>>> ***Just enhancement ideas***
>>>>   - Support for trace-cmd
>>>>   - Support for 9pfs protocol
>>>>   - Support for non-blocking mode in QEMU
>>>
>>> There were patches long back (by me) to make chardevs non-blocking but
>>> they didn't make it upstream.  Fedora carries them, if you want to try
>>> out.  Though we want to converge on a reasonable solution that's
>>> acceptable upstream as well.  Just that no one's working on it
>>> currently.  Any help here will be appreciated.
>>
>> Thanks! In this case, since a guest will stop to run when host reads
>> trace data of the guest, char device is needed to add a non-blocking
>> mode. I'll read your patch series. Is the latest version 8?
>> http://lists.gnu.org/archive/html/qemu-devel/2010-12/msg00035.html
>
> I suppose the latest version on-list is what you quote above.  The
> objections to the patch series are mentioned in Anthony's mails.

I'll check the mails.

> Hans maintains a rebased version of the patches in his tree at
>
> http://cgit.freedesktop.org/~jwrdegoede/qemu/
>
> those patches are included in Fedora's qemu-kvm, so you can try that
> out if it improves performance for you.

Thanks. I'll check those patches.

>>>>   - Make "vhost-serial"
>>>
>>> I need to understand a) why it's perf-critical, and b) why should the
>>> host be involved at all, to comment on these.
>>
>> a) To make collecting overhead decrease for application on a guest.
>>     (see above)
>> b) Trace data of host kernel is not involved even if we introduce this
>>     patch set.
>
> I see, so you suggested vhost-serial only because you saw the guest
> stopping problem due to the absence of non-blocking code?  If so, it
> now makes sense.  I don't think we need vhost-serial in any way yet.

I understood. We suggested vhost-serial as one of the ideas for
improving performances. Other features(trace-cmd, 9pfs, and
non-blocking chardev) should be supported first, I think.

> BTW where do you parse the trace data obtained from guests?  On a
> remote host?

It is the best that we can parse the data on a remote host in this
tracing system. Existing trace-cmd can already parse it on a remote
site. If we add the feature collecting event-format data(guest's
debugfs has that) from guests, we can parse tracing data on a remote
host as well as on a host running guests.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


