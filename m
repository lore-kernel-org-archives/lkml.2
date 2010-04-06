Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0DFQHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:07:06 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:43036
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab0DFQHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:07:02 -0400
Message-ID: <4BBB5C1F.5060407@cfl.rr.com>
Date: Tue, 6 Apr 2010 12:06:55 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Extended partition mapping wrong size
References: <4BB0D12B.6060701@cfl.rr.com> <20100406114706.GA30340@nb.net.home> <4BBB3E0F.1030309@cfl.rr.com> <20100406153348.GE7858@nb.net.home>
In-Reply-To: <20100406153348.GE7858@nb.net.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2010 11:33 AM, Karel Zak wrote:
> You have to care about the partition table (EBR).
> 
> The current 1024 bytes is completely useless size, if you enlarge the
> size of the partition (for example to 1MiB) you will see reports from
> people who lost their extended partitions. (I don't believe that all
> mkfs programs are able to detect/skip EBR.)

Good point... mke2fs won't damage it since it leaves the first sector
intact and places its boot sector in sector 1 ( or was it 2? ), but FAT
and NTFS won't be so kind.

>> Then again, I could swear that once upon a time the kernel simply
>> did not bother creating a dev node for the extended partition, and
>> this seems to be a hack that was put in to make it easy for LILO to
>> install to one.  Personally I'd prefer going back to the old
>> behavior of just not having a useless device there.
> 
> This is probably better idea than enlarge the size :-)

Aye, I'd prefer the useless device to be removed, but at the very least
it should not use a size of 2 when the second sector is not actually
there because it is the first sector of the logical partition, though we
just patched parted to reserve that second sector anyhow even though you
are using none alignment mode, just to avoid running into this problem.
