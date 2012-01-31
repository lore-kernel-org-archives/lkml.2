Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2AaL7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:59:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54240 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2AaL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <4F27CDBC.5020201@suse.cz>
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz> <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
 <4F27C9D4.3040105@suse.cz> <CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
 <4F27CDBC.5020201@suse.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 31 Jan 2012 12:58:46 +0100
Message-ID: <CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com>
Subject: Re: network regression: cannot rename netdev twice
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 12:17, Jiri Slaby <jslaby@suse.cz> wrote:
> On 01/31/2012 12:13 PM, Kay Sievers wrote:

>> This is a command sequence you type manually?
>
> Yea, and it is working with 3.3.0-rc1-next-20120124_64+. Not with
> 3.3.0-rc1-next-20120131_64+.
>
>> You are sure that userspace is not working in the background,
>> triggered by uevents, and comes into your way here?
>
> Note that krtek exists after the first command. But cannot be renamed
> further.

Yeah, I can confirm the problem here. I works fine with earlier
kernels and fails with the latest -next:

# uname -r
3.3.0-rc1-next-20120131+
# modprobe dummy
# ip link set dummy0 name foo0
# ip link set foo0 name bar0
RTNETLINK answers: No such file or directory

Kay
