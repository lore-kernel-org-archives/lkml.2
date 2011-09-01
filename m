Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1IAI3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:29:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47205 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab1IAI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:29:17 -0400
Message-ID: <4E5F4258.8030008@suse.cz>
Date: Thu, 01 Sep 2011 10:29:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/4] TTY: serial, fix build of some drivers
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz> <1314818699-10873-3-git-send-email-jslaby@suse.cz> <20110831222850.494bf19d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110831222850.494bf19d@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 11:28 PM, Alan Cox wrote:
> On Wed, 31 Aug 2011 21:24:58 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> I'm getting build errors such as:
>> .../tty/serial/max3107.c: In function ‘put_data_to_circ_buf’:
>> .../tty/serial/max3107.c:149:2: error: implicit declaration of function ‘tty_insert_flip_string’
>>
>> Those drivers need to include linux/tty_flip.h. The question is
>> whether we want to fix them at all. As they are broken for some time
>> already and nobody noticed...
> 
> Config options randomly including it ?

Ah, no, ignore that comment. I realized that I removed linux/tty_flip.h
inclusion from serial_core.h. I moved the big inlines out of the header
and the inclusion was no longer needed there.

Hence these failures. And I think there will be more. So please apply
the patch, it's correct, except the changelog.

thanks,
-- 
js
suse labs
