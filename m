Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2BHAjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:39:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab2BHAi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:38:59 -0500
Message-ID: <4F31C417.30502@redhat.com>
Date: Tue, 07 Feb 2012 19:38:47 -0500
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
References: <1328623901-20628-1-git-send-email-ajax@redhat.com> <1328657985-13942-1-git-send-email-ajax@redhat.com> <20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
In-Reply-To: <20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/12 7:17 PM, Alan Cox wrote:
> On Tue,  7 Feb 2012 18:39:45 -0500
> Adam Jackson<ajax@redhat.com>  wrote:
>
>> This is like /dev/port except not broken.  /dev/port will translate all
>> read/write into inb/outb streams, which is wrong since hardware can and
>> does care about cycle size.  /dev/io will only allow 1, 2, or 4 byte
>> access, and will translate that into the appropriate bus cycle size.
>
> From a security perspective /dev/[k][mem is a dumb bit of ancient Unix
> history we'd dearly like to kill off. /dev/port is a similar early PC
> unixism that wants to go the same way. /dev/io just adds another horror
> to the pile.
>
> Please do the decent thing, stop using /dev/mem and /dev/port for
> anything. If you need to access an I/O device make it properly visible
> via the kernel only for the ports and in a manner that is safe.

Yeah, I'll be sure to do that right as soon as I can stop supporting the 
vesa driver.  Until that time I don't really have any choice but to 
expose the whole of I/O port space, since I have no idea what the video 
BIOS is going to touch.

I don't disagree with wanting to limit access to these services, but 
/dev/io is at least somewhat containable, whereas iopl is insane.

- ajax

