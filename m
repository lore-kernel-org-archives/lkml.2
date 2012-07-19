Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2GSJjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:39:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61773 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2GSJjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120718175625.GD21746@redhat.com>
References: <20120718171812.GC21746@redhat.com> <CAPXgP12PioibfQhtAB0fCzL1MXmZvfvQqOGu_ZM0D8Sx4Vq7+w@mail.gmail.com>
 <20120718175625.GD21746@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 19 Jul 2012 11:38:57 +0200
Message-ID: <CAPXgP12YasX6mBVOamO8Tk1mcFJ04XWh5CjuTRxhRShncgVCtA@mail.gmail.com>
Subject: Re: [PATCH] printk: Export struct log size and member offsets through vmcoreinfo
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 7:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jul 18, 2012 at 07:27:08PM +0200, Kay Sievers wrote:
>> On Wed, Jul 18, 2012 at 7:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> > Currently I am not exporting log "level" info as that is a bitfield and
>> > offsetof() bitfields can't be calculated.
>>
>> We could make the level the lower 3 bits of the byte, export the byte,
>> and define that only 3 bits of the byte are valid? Would that help?
>
> Yes, that should work. Here is the prototype patch which stores 5 bits
> of flag and 3 bits of level in a byte. I have not tested it yet, but
> if you like the approach, I will test it.

> -       u8 flags:5;             /* internal record flags */
> -       u8 level:3;             /* syslog level */
> +       u8 flags_level;         /* 5 bit internal record flags, 3 bits syslog

Looks ok.

If we would swap the 5 + 3 bit field byte declaration, and add
__packed, we can still not rely on the level to be consistently the
lower 3 bits of the byte, right?

Thanks,
Kay
