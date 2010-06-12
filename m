Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0FLHHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:07:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40427 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0FLHHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R5HNxPHy+kRyeZM4Uruy41+iyUkscvXAcDjgsP4c8jbuVyLgrn83uCJ+4M7EFaBDFi
         ha47IGLpsk9uga54knGauFt56HJa2NebEfiwlfzi6tgo3NuIG1Q+xIFFnwqY6D1rZvA4
         PYo91/k4deeCfVfB8JuHrzfJrF1kyWT2pvHMI=
MIME-Version: 1.0
In-Reply-To: <x498w6liejl.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTilXU8paNWNUSQIjcQ7xaaWgB1bEyd70d5P_nWf2@mail.gmail.com>
	<x498w6liejl.fsf@segfault.boston.devel.redhat.com>
Date: Sat, 12 Jun 2010 12:37:02 +0530
Message-ID: <AANLkTimBxuQC4-Pm2OAl2mBb1h_rP1b-V9q2G7jEvfTv@mail.gmail.com>
Subject: Re: O_NONBLOCK with Ext3
From: "Yedire, Sandeep" <syedire@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2010 00:26, Jeff Moyer <jmoyer@redhat.com> wrote:
> "Yedire, Sandeep" <syedire@gmail.com> writes:
>
>> Hi ALL,
>> I am currently using o_nonblock flag for writing a file of 64MB over a
>> flash device. Flash is formatted with ext3 filesystem with default
>> options.
>> When instrumented the driver code for collecting the erase/write count
>> at sector level. I noticed that o_nonblock has no effect on this
>> count. There is no difference in erase/write count with o_nonblock
>> flag or without this flag.
>> When selected Ext2 as filesystem I noticed a significant difference in
>> the erase/write count.
>> There were more updates with o_nonblock and test application was
>> faster. I could confirm this by checking the Dirty page limit in the
>> background. It was updating faster in case of Ext2 not incase of Ext3.
>>
>> Can any one explain on o_nonblock flag in case of  Ext3 filesystem?
>
> The O_NONBLOCK flag should be ignored when opening files on a file
> system.  I'm not sure how to explain your observations.
>
> What exactly were you trying to accomplish?
>
> Cheers,
> Jeff
>
--
[Sandeep]
> What exactly were you trying to accomplish?
>
I am only trying to observe the difference with O_NONBLOCK flag in the
updates to filesystem blocks and data blocks in Ext2 and Ext3
filesystem.

It was observed that with O_NONBLOCK flag in Ext2 there were less
updates to Filesystem block at sector 0, and frequent updates to data
blocks. This is not the case with Ext3.

Sandeep
