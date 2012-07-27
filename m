Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2G0GZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:25:10 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:51631
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab2G0GZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:25:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6R6OuHN000849
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Problem with commit cf03c5dac83609f09d9f0e9fa3c09d86daed614d
In-Reply-To: <gizk6mjtmy.fsf@mx10.gouders.net> (Dirk Gouders's message of
	"Thu, 26 Jul 2012 19:53:57 +0200")
References: <gik3xqtzw3.fsf@karga.hank.lab>
	<20120726134926.GA10452@thinkpad-t410>
	<gi7gtqlfw2.fsf@mx10.gouders.net>
	<20120726152121.GB10452@thinkpad-t410>
	<gizk6mjtmy.fsf@mx10.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 27 Jul 2012 08:24:54 +0200
Message-ID: <givch9k9ft.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 27 Jul 2012 08:24:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:

> Seth Forshee <seth.forshee@canonical.com> writes:
>
>> On Thu, Jul 26, 2012 at 05:07:57PM +0200, Dirk Gouders wrote:
>>> Hi Seth,
>>> 
>>> thanks for your reply and sorry for the noise.
>>> 
>>> I followed your advice and tried to boot with the WLAN interface turned
>>> off, and the problem still exists.  I'll start a new bisect session,
>>> probably with one of the commits you mentioned as the first good commit.
>>
>> Just to make sure three's not any confusion ...
>>
>> What I was suggesting was not just disabling the network interface but
>> completely preventing brcmsmac from being loaded. The oops you saw
>> happens in the context of the driver's probe function and would happen
>> regardless of whether or not the interface is enabled.
>
> Sorry for the confusion.
>
> I already started a new bisect session, with a bad commit I disabled
> brcmsmac in the kernel config and the problem still exists.  Now, I
> continue with brcmsmac disabled and will see where the bisect ends.

Hi Seth,

I just want to let you know that the problem with my laptop has been
fixed.

Yesterday, I found commit b9562545ef0b to cause the problem
and after a pull this morning I noticed that the problem introduced by
it has been fixed by commit 1f03bf06e4e3 (bcma: fix invalid PMU chip
control masks).

Thanks again for your help.

Dirk
