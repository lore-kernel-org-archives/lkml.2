Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1DHKuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 06:50:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37505 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1DHKuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 06:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mTJs8sf24CUmtoSoGdVuPC0nC5Ld2woskKkTYGNNOJCbvx1agFJ4IrwbxkA6grd2wS
         g7bPj3C5KDq9/Kc56TCOogXzn5QU8DGqG1XDOVSLX3UQ4l7FMX+Ak5Q0mfbs8/itek2Z
         IzTgJI2zF7dl3bb5FpOz/UKf1pf9KG0n85g3M=
MIME-Version: 1.0
In-Reply-To: <20110407131250.GA1571@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
	<BANLkTimXRcKyWdUxS2TRzibcSUdCfObH3g@mail.gmail.com>
	<20110407131250.GA1571@aepfle.de>
Date: Fri, 8 Apr 2011 18:49:15 +0800
Message-ID: <BANLkTim=Sch-ZM-N=oDkg+N5F-WPGV4qNQ@mail.gmail.com>
Subject: Re: dynamic oldmem in kdump kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 9:12 PM, Olaf Hering <olaf@aepfle.de> wrote:
> On Thu, Apr 07, Américo Wang wrote:
>
>> On Thu, Apr 7, 2011 at 5:56 PM, Olaf Hering <olaf@aepfle.de> wrote:
>> > Another issue, slightly related, is memory hotplug.
>> > How is this currently handled for kdump?  Is there code which
>> > automatically reconfigures the kdump kernel with the new memory ranges?
>> >
>>
>> No, the crashkernel memory is reserved during boot, and it is static after
>> that (except you can shrink this memory via /sys).
>
> I meant the overall amount of memory changed by memory hotplug events,
> not the small memory range for the crash kernel itself.
>
>> Kdump isn't aware of memory hotplug.
>
> Ok.  Perhaps there are hotplug events where a helper script could run
> something like 'rckdump restart'.
>

That will not work.

You need to change the kernel to let crashkernel memory to be aware
of memory-hotplug, which means you need to re-search for a suitable
memory range in the newly added memory.

Thanks.
