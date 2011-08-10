Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1HJSKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:10:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45784 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1HJSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:10:38 -0400
Message-ID: <4E42C998.1050208@gmail.com>
Date: Wed, 10 Aug 2011 20:10:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz> <20110719003503.GA4138@amos.fritz.box> <4E3FE2D2.5020801@gmail.com> <20110810010933.GA4733@amos.fritz.box> <4E429907.6080000@gmail.com> <20110810180754.GB13832@bombe-desk.opditex>
In-Reply-To: <20110810180754.GB13832@bombe-desk.opditex>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 08:07 PM, Andreas Bombe wrote:
> On Wed, Aug 10, 2011 at 04:43:19PM +0200, Jiri Slaby wrote:
>> On 08/10/2011 03:09 AM, Andreas Bombe wrote:
>>> I did my simple test on ttyS0 again: "stty -F /dev/ttyS0 crtscts" then
>>> "echo >/dev/ttyS0". I attached the gzipped sysrq-t list in case you need
>>> the complete output. This is just the process while it is trying to
>>> close the device (bash's internal echo):
>>
>> Hmm, perhaps obvious question. What is the port connected with? And with
>> what cable? Is it null modem cable? Or at least with DTR-CTS connected?
> 
> Nothing is connected. After all, the whole point of this exercise is to
> give the driver data to send which it can't get out so I can see whether
> it blocks all tty operations system wide while trying to do the flush on
> close.

But according to the trace, it waits only in its queue...

Well, could you turn on lockdep and dump sysrq-d when your echo is
closing the port?

thanks,
-- 
js
