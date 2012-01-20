Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2ATPVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:21:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2ATPVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120120145907.GA20377@x2.net.home>
References: <20120120140444.GC13157@x2.net.home> <20120120154309.3ae5f9e4a8f55c477dc423ab@kinali.ch>
 <20120120145907.GA20377@x2.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 20 Jan 2012 16:20:56 +0100
Message-ID: <CAPXgP11f_SicmxSZ1Bb5JmM4krPyNL-rXNJ6rJ2BHrNvA8LzRQ@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Karel Zak <kzak@redhat.com>
Cc: Attila Kinali <attila@kinali.ch>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 15:59, Karel Zak <kzak@redhat.com> wrote:
> On Fri, Jan 20, 2012 at 03:43:09PM +0100, Attila Kinali wrote:
>> Hence, i would like to ask you to consider not adding /etc/fstab.d
>> unless there is a very good reason to do it. And "to make it simpler
>> for people who have a lot of mountpoints" is IMHO not a good reason.
>> How many mountpoints must one use that a single file becomes a problem?
>
>  Let's imagine that you have a network and you use the same configuration
>  on all machines, then "*.d/" directories are very useful for you -- for
>  example you can create a company.rpm with important configuration and
>  distribute it to all machines.

Yeah, and all tools which read /etc/fstab with the glibc interface, to
find out the properties for the mount point, are just broken now. And
for what gain. Put a script in you RPM that merges your snippets into
the one fstab, and you get the same behaviour without any breakage.

Always remember, /etc/fstab is ABI, not a private config file, you
need a _very_ good reason to break it.

And you usually have not much problems convincing me that breakage is
justified. I just totally fail to see the benefit vs. gain in this
case.

Kay
