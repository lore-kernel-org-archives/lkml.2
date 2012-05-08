Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2EHPq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:46:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45518 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2EHPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:46:54 -0400
Message-ID: <4FA93FEB.2060200@wwwdotorg.org>
Date: Tue, 08 May 2012 09:46:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: Regression due to d29f3ef "tty_lock: Localise the lock"
References: <4FA8557E.5080402@wwwdotorg.org> <20120508103512.42db1c4b@pyramind.ukuu.org.uk>
In-Reply-To: <20120508103512.42db1c4b@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:35 AM, Alan Cox wrote:
> On Mon, 07 May 2012 17:06:38 -0600
> Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Alan,
>>
>> Commit d29f3ef "tty_lock: Localise the lock" appears to cause a problem
>> for me.
>>
>> With this commit (as in next-20120507), I can no longer log into my
>> system (NVIDIA Tegra device with ARM CPU) over the serial console, since
>> the login prompt no longer appears. If I wait a few minutes, I see the
>> following console spew:
> 
> Eep. If it's reproducable can you test whether adding the unlock/relock
> in drivers/tty/pty.c does the trick ?
> 
> ie:
> 	tty_unlock(tty);
> 	tty_vhangup(tty);
> 	tty_lock(tty);

Yes, that change in pty_close() solves the problem.

> or if changing it for tty_hangup(tty) does it.

Assuming that means s/tty_vhangup/tty_hangup/ in pty_close(), then yes
that fixes it too.

Thanks.
