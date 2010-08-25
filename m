Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab0HYHke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:40:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55741 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0HYHkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20100824231241.GA6971@suse.de>
References: <20100622232108.26752ff8@lxorguk.ukuu.org.uk> <1277462596.2143.101.camel@itpsd6lap>
 <20100625120329.1303aa61@lxorguk.ukuu.org.uk> <1282683470.8020.66.camel@itpsd6lap>
 <20100824211016.GA7176@suse.de> <1282687797.8020.108.camel@itpsd6lap>
 <20100824222035.GA10625@suse.de> <1282690232.8020.116.camel@itpsd6lap>
 <20100824225703.GA5913@suse.de> <20100825002221.68fc09a4@lxorguk.ukuu.org.uk> <20100824231241.GA6971@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 25 Aug 2010 09:40:16 +0200
Message-ID: <AANLkTi=SkVv4tYUuAr9n03iYFdTJQr7wQnFaodrkHpom@mail.gmail.com>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 01:12, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 25, 2010 at 12:22:21AM +0100, Alan Cox wrote:
>> > No, it does cover that.  You should be able to do that with a simple
>> > console redirection to /dev/kmsg  What happened when you tried to do
>> > that?
>>
>> stty: standard input: Inappropriate ioctl for device
>
> Kay, how does systemd handle the kmsg console redirection?

Systemd does not steal the console, this is done by plymouth, in the
same way blogd can do that. It uses a pty and rewrites the messages.

Systemd does pass syslog to the kernel buffer during early boot. Init
provides /dev/log. With systemd, the started services usually don't
get the console connected, but use syslog anyway or the stdout/err
gets redirected to syslog.

With systemd the console is not too useful because we start everything
in parallel. If all the services would put out stuff there like sysv
did, it would look like a real mess.

Kay
