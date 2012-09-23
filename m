Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2IWOqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 10:46:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41825 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2IWOqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 10:46:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20120923064007.GA2994@moon>
References: <20120913095623.GB28508@moon> <20120913135131.5b251797@pyramind.ukuu.org.uk> <20120913125401.GK19956@moon> <20120913172507.5039e3c6@pyramind.ukuu.org.uk> <20120922180639.GC11610@moon> <20120922200731.GD14004@kroah.com> <20120922201144.GD11610@moon> <20120922215232.GA25778@moon> <20120923010953.GA17663@kroah.com> <20120923064007.GA2994@moon>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Sep 2012 07:46:24 -0700
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Message-ID: <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>On Sat, Sep 22, 2012 at 06:09:53PM -0700, Greg Kroah-Hartman wrote:
>> On Sun, Sep 23, 2012 at 01:52:32AM +0400, Cyrill Gorcunov wrote:
>> > On Sun, Sep 23, 2012 at 12:11:44AM +0400, Cyrill Gorcunov wrote:
>> > >
>> > > > Sysfs is one value per file, you have three values here, please
>make 3
>> > > > files.
>> > > > 
>> > > > And document them in Documentation/ABI/.
>> > > 
>> > > Hmm, sure Greg, I'll update. Thanks!
>> > 
>> > Something like below I suppose? Look, if there will be no complains
>> > on tech aspects on the patch (locking and tty refs) -- I'll update
>> > Documentation. Just want be sure I've made no mistakes here.
>> > 
>> > Another question -- would not it be worth to wrap code with
>> > CONFIG_CHECKPOINT_RESTORE?
>> 
>> Alan's point stands, what's the use of this if it can instantly
>change
>> after you read the value?
>
>We use it when we do a checkpoint, ie when tasks are stopped. I think
>it's
>close to data obtained from procfs (ie valid once you read it but can
>be
>changed right after that operation). Maybe I should put everything to
>procfs, or stick back with ioctl calls?

The problem as I see it is that you don't know if your process is the lock holder.
-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
