Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2FSOfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:35:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2FSOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <4FE0A30C020000780008AA0B@nat28.tlf.novell.com>
References: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
 <CAPXgP13y_xOUzHdStsDWescPtJYn0nvMhsQ7c2XS3HBuE=jwow@mail.gmail.com> <4FE0A30C020000780008AA0B@nat28.tlf.novell.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 19 Jun 2012 16:34:47 +0200
Message-ID: <CAPXgP13F5dVRzW3wDLM4dCOJ=9+fztUHsBLXkV=shJ=KkDqT=g@mail.gmail.com>
Subject: Re: printk behavioral regression
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 4:04 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 19.06.12 at 15:53, Kay Sievers <kay@vrfy.org> wrote:
>> On Tue, Jun 19, 2012 at 3:30 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>> running 3.5-rc3 on a SLE11 SP1 system, early boot messages (apart
>>> from the very first one) end up in /var/log/messages rather than
>>> /var/log/boot.msg. I didn't dig deep enough yet to figure out what
>>> is causing this, and would hope that you (having contributed most
>>> of the changes between 3.4 and 3.5-rc3) might have an idea.
>>
>> Hmm, no idea really, and why this should change.
>
> Okay, then I'll indeed need to do some debugging.
>
>> /var/log/boot.msg is a SUSE speciality, that, as far as I know, just
>> dumps 'dmesg' after bootup, it has not much to do with the normal
>> syslog/klog logging in /var/log/messages, where all your messages should
>> always end up, and what seems to work for you.

Sure? The /var/log/boot.msg gets overwritten with every reboot, I
don't remember losing all bootup messages in syslog on SUSE; and that
would seriously weird if it behaves like that.

> No, boot messages (at least by default) end up _only_ in
> /var/log/boot.msg, and thus significantly help keeping the size
> of /var/log/messages down. SUSE specialty or not, there
> clearly is some user space visible change here.

Look out for the SUSE tool blogd and how that is involved in getting
these messages from the kernel.

And there is a fix pending in Greg's tree:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commit;h=4a77a5a06ec66ed05199b301e7c25f42f979afdc

which is supposed to fix a different issue, but we can never know ...

Kay
