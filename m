Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2AaOPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:15:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59524 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2AaOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:15:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Subject: Re: network regression: cannot rename netdev twice
References: <4F27120A.4040106@suse.cz>
	<CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
	<4F27C54F.1010107@suse.cz>
	<CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
	<4F27C9D4.3040105@suse.cz>
	<CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
	<4F27CDBC.5020201@suse.cz>
	<CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com>
Date: Tue, 31 Jan 2012 06:18:00 -0800
In-Reply-To: <CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com>
	(Kay Sievers's message of "Tue, 31 Jan 2012 12:58:46 +0100")
Message-ID: <m18vko6jmv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+lUSvI1y7IvAPJUMidyUx+XyuJ6eL/DwI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Tue, Jan 31, 2012 at 12:17, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 01/31/2012 12:13 PM, Kay Sievers wrote:
>
>>> This is a command sequence you type manually?
>>
>> Yea, and it is working with 3.3.0-rc1-next-20120124_64+. Not with
>> 3.3.0-rc1-next-20120131_64+.
>>
>>> You are sure that userspace is not working in the background,
>>> triggered by uevents, and comes into your way here?
>>
>> Note that krtek exists after the first command. But cannot be renamed
>> further.
>
> Yeah, I can confirm the problem here. I works fine with earlier
> kernels and fails with the latest -next:
>
> # uname -r
> 3.3.0-rc1-next-20120131+
> # modprobe dummy
> # ip link set dummy0 name foo0
> # ip link set foo0 name bar0
> RTNETLINK answers: No such file or directory

There is something weird going on when sysfs directories and symlinks
are renamed.  My guess is that I fat fingered something with one of my
last sysfs patches.  I will look more deeply once I have slept some
more.

The second network device renames fails because the first rename did not
work properly.  ls -l /sys/class/net/ /sys/virtual/net/ will let you see
what I mean.

Eric
