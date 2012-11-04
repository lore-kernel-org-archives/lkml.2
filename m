Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2KDWhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 17:37:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33824 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2KDWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 17:37:33 -0500
Message-ID: <5096EE29.8090304@suse.cz>
Date: Sun, 04 Nov 2012 23:37:29 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jiri Slaby <jirislaby@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: microsoft, fix invalid rdesc for 3k kbd
References: <1350646126-28537-1-git-send-email-jslaby@suse.cz> <CAMuHMdWzNxhs1+14qwr0=G+_uGVWm9QKb4wBDBy-6rx5+pxv7w@mail.gmail.com>
In-Reply-To: <CAMuHMdWzNxhs1+14qwr0=G+_uGVWm9QKb4wBDBy-6rx5+pxv7w@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 10:06 PM, Geert Uytterhoeven wrote:
> On Fri, Oct 19, 2012 at 1:28 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> +       if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
>> +                       !memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
>> +                               &rdesc[94], 4)) {
> 
> Which version of gcc are you using?

4.7.1. But that indeed fails too if memcmp is a macro. This is of course
not the case for x86, so that I didn't hit that. I will post a patch to
change this to standard array accesses. (This looked prettier though.)

@Greg: please drop that patch from the stable queues for now.

thanks,
-- 
js
suse labs
