Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2BHRg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:36:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48395 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2BHRg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:36:56 -0500
Message-ID: <4F32B2A0.70405@zytor.com>
Date: Wed, 08 Feb 2012 09:36:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Paul Parsons <lost.distance@yahoo.com>, Kirill Smelkov <kirr@mns.spb.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
References: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com> <4F32AECE.4010308@zytor.com> <CAPXgP10OcEc1J4VkCfbMowYR=Ou_F+SqKdDA5kaUAUgjfeiBsw@mail.gmail.com>
In-Reply-To: <CAPXgP10OcEc1J4VkCfbMowYR=Ou_F+SqKdDA5kaUAUgjfeiBsw@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 09:25 AM, Kay Sievers wrote:
> On Wed, Feb 8, 2012 at 18:20, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/08/2012 08:44 AM, Paul Parsons wrote:
>>>
>>> Could you simply use /etc/fstab to identify the root partition?
>>>
>>
>> That's not a very good thing, as it is much more likely to be wrong.
>>
>> It would be a good thing to have the /dev/root symlink *IF* a valid root
>> device exists (defined as a device node appearing which has the same
>> device number as reported by stat on the root directory), if nothing
>> else because we have had one available for a very long time and this is
>> needless breakage.
>>
>> Obviously, if such a device doesn't exist (btrfs, NFS, tmpfs) then don't.
> 
> Tools should just do the equivalent of:
>   $ ls -l /sys/dev/block/$(mountpoint -d /)
>   /sys/dev/block/8:1 ->
> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1
> 
> and all is fine. I'm convinced, that determining the root device is a
> job for *running code* not to expect a symlink to be around.
> 
> Kay

Okay, first of all, this is a service (you can think of it as such)
which has been provided for a long time.  It can be done with minimal
effort as devices appear, so you don't need to scan the /dev directory
to find the device node that corresponds to the above (as you know,
there are deliberately no device nodes in /sys, although *most* of the
time you obviously have the name right there.)

I'm not saying you're wrong, I'm saying you should consider it a
backwards compatibility solution for an interface which has been
provided for a long time already.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

