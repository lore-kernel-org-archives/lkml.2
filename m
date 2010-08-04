Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0HDWEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:04:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51902 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0HDWEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:04:15 -0400
To: Greg KH <greg@kroah.com>
Cc: Michael Leun <lkml20100708@newton.leun.net>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: NET_NS: unregister_netdevice: waiting for lo to become free (after using openvpn)
References: <loom.20100708T183152-326@post.gmane.org>
	<20100709235744.GA12752@kroah.com>
	<20100710101540.2799c9ef@xenia.leun.net>
	<20100710140800.GA20424@kroah.com>
	<20100710165208.59272ae6@xenia.leun.net>
	<20100710235323.5336f627@xenia.leun.net>
	<20100711192939.1c25dcaf@xenia.leun.net>
	<20100804153543.56f6ecad@xenia.leun.net>
	<20100804214618.GA6289@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 15:04:08 -0700
In-Reply-To: <20100804214618.GA6289@kroah.com> (Greg KH's message of "Wed\, 4 Aug 2010 14\:46\:18 -0700")
Message-ID: <m1ocdi6nmv.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Wed, Aug 04, 2010 at 03:35:43PM +0200, Michael Leun wrote:
>> Hi,
>> 
>> On Sun, 11 Jul 2010 19:29:39 +0200
>> Michael Leun <lkml20100708@newton.leun.net> wrote:
>> 
>> [...]
>> > Jul 10 20:02:36 doris kernel: unregister_netdevice: waiting for lo to
>> > become free. Usage count = 3 [repeated]

Does this repeat indefinitely, or are there only a couple of repetitions?
If this repeats indefinitely every 5 seconds or so we have a serious bug.

Otherwise we just have cleanup taking longer than it should, which isn't
ideal but it is much less severe.

>> > Now one might say it is fault of openvpn (used OpenVPN 2.1_rc20
>> > i586-suse-linux - the one in openSuSE 11.2 package), openvpn didn't
>> > close some ressource and ssh does fine.
>> > 
>> > But: should'nt kernel clean up after process when it exits?
>> > And/or: Should'nt kernel clean up if last process in network namespace
>> > exits - there is nothing left which might use that interface?!
>> > 
>> > Greg KH <greg@kroah.com> wrote:
>> > 
>> > > Yes, you are correct.  Care to resend all of this to the
>> > > network-namespace developer(s) and the netdev mailing list so that
>> > > the correct people are notified so they can fix it all?
>> > 
>> > [X] done - hopefully, cannot find a particular network namespace
>> > developer in MAINTAINERS or source files. If such a one exists, please
>> > forward.
>> 
>> Did'nt work. Got no reaction from network mailinglist at all and bug
>> still is in 2.6.35.
>
> Eric, here's a bug with the network namespace stuff, care to work on
> resolving it?

Greg thanks for forwarding this in my direction.

Eric
