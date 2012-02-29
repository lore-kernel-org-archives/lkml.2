Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2B2V0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 16:26:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34757 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2B2V0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 16:26:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paolo.bonzini@gmail.com designates 10.14.120.210 as permitted sender) smtp.mail=paolo.bonzini@gmail.com; dkim=pass header.i=paolo.bonzini@gmail.com
Message-ID: <4F4E97EE.2090706@redhat.com>
Date: Wed, 29 Feb 2012 22:26:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] block: avoid false positive warnings on ioctl to partition
References: <1329464338-8351-1-git-send-email-pbonzini@redhat.com> <4F4B78CE.4010405@redhat.com> <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com> <4F4DDE14.8050406@redhat.com> <CADU53JUvh1a=0NgN87jV24PLY6GJma2bW=kFK_5ejFEp1djwEQ@mail.gmail.com>
In-Reply-To: <CADU53JUvh1a=0NgN87jV24PLY6GJma2bW=kFK_5ejFEp1djwEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/02/2012 20:56, Ray Lee ha scritto:
> On Wed, Feb 29, 2012 at 12:13 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> Il 29/02/2012 01:14, Linus Torvalds ha scritto:
>>> So I'm still not convinced this is safe, and feel a bit worried about
>>> us possibly silently missing some things. That
>>>
>>>    default:
>>>       return -ENOIOCTLCMD;
>>>
>>> is what worries me.
>>>
>>> Blocking the ones we *know* about and understand I'm perfectly fine
>>> with. And the SG_IO case looks fine. It's the possibly unknown users
>>> that still worry me.
>>
>> I understand.
>>
>> But being 100% sure that nothing breaks is
>> impossible, unfortunately, so does it make sense to aim at 100%?  And it
>> should be extremely easy to bisect failures.  Even with all the
>> differences, it reminds me of the recent change to poll.
> 
> You can help avoid the bisect entirely by silently dropping the ones
> you're sure about, and noisily dropping the ones you aren't.

It's not so easy, see http://permalink.gmane.org/gmane.linux.kernel/1244476.

Paolo
