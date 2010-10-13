Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0JMGiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:38:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38368 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0JMGiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kmOjucPldJeqOXifF1OpI9MxdX86HzzGo8r0tLLmxjrG9Da78BQO1b7HbcDI9pwP9M
         f3xMrF+X4qAX4qJxDaoPExEptkZs5KkFNoDY6GMYDd7OvSbFBL9nJpfH0uS7yDbnlYi7
         85Nyzhe3qdvLri5QEB2WrOKlmXaj0crBWP4p4=
MIME-Version: 1.0
In-Reply-To: <20101013062605.GB4393@suse.de>
References: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
	<20101013062605.GB4393@suse.de>
Date: Wed, 13 Oct 2010 15:38:13 +0900
X-Google-Sender-Auth: IIUwG1SEeM5MK3cv8VYaVrZZXxc
Message-ID: <AANLkTimc-ETu4zrny=kmVRq8jnh2CDiVSqE-EXde4ioS@mail.gmail.com>
Subject: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted condition.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Stanislav Brabec <sbrabec@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 3:26 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 13, 2010 at 02:58:06PM +0900, MyungJoo Ham wrote:
>> When console_suspend_enabled == 0, console_stop() was not called at
>> suspend; thus, it does not need to call console_start() when resume.
>> Besides, calling console_start() without calling console_stop() before
>> had been incurring kernel hang with console_suspend_enabled == 0 in a
>> machine with drivers/serial/samsung.c and s5pc210.
>
> Is this a regression?  If so, from what working kernel?  Or has this
> always been this way?
>
> thanks,
>
> greg k-h
>


I don't think this is a regression to the previous version. Logically,
it's matching the console_stop()-console_start() pair.

Such hang in serial and its mitigation is observed in 2.6.36 at
arch/arm/mach-s5pv310 machines. In these machines, it hanged with
console_suspend_enabled == 0 every time.



Cheers!

- MyungJoo

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
