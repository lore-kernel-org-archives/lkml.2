Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2FMPPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:15:04 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:55690 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab2FMPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:15:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIBAG6Zu08Y9geI/2dsb2JhbAANN4UtqxuGZgEBAQEDI1UBEAsOCgICBRYLAgIJAwIBAgFFBg0BBwEBrxiSe4EmjgqBFAOoEA
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="191295080"
Message-ID: <4FD8AE74.3080708@teksavvy.com>
Date: Wed, 13 Jun 2012 11:15:00 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mahmood Naderan <nt_mahmood@yahoo.com>
CC: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: logging on kernel panic
References: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com> <20120613133927.73c44f09@pyramind.ukuu.org.uk> <alpine.LRH.2.00.1206131552440.6369@twin.jikos.cz> <1339599156.30833.YahooMailNeo@web111716.mail.gq1.yahoo.com>
In-Reply-To: <1339599156.30833.YahooMailNeo@web111716.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-06-13 10:52 AM, Mahmood Naderan wrote:
>
>> The kernel log may not hit /var/log/syslog when kernel panics,
> Can I ask why. Just before a panic, kernel is still alive and can log. 
> Isn't that?

The kernel writes log messages to a circular in-RAM fifo (/proc/kmsg).
They then later get saved to a file such as /var/log/syslog by some
userspace task, eg. rsyslogd or syslogd.

At the point a Kernel Panic, the kernel is considered "dead",
or "non trustworthy" due to the error condition that triggered the panic.
Attempting to continue after the panic would be unwise,
with the possibilities including opening huge security holes/leaks
and/or corrupting user data.

So it is no longer alive, and will not be scheduling the userspace tasks
that might copy the log to a file for you.  Thus, nothing gets saved.



