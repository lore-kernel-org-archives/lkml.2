Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1DOXZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:25:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62744 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1DOXZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=j8mMknjI0bEYDrD1BtdmhgOQCjmLJHXTglwqmPBxqTs3rFm35lL1G6wPSfatsnrBo2
         fi18ht1T/fEHRTTIYXj7Q9WcrYCumuEP196FiOmH4JIac+VmGZw25+eAl/iScptKvAnF
         F7rLOAa7SbsOQvIBoVlu66FKYf5tob0bIoX/Q=
MIME-Version: 1.0
In-Reply-To: <201104160111.49409.rjw@sisk.pl>
References: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com>
 <20110415162938.GA11454@atrey.karlin.mff.cuni.cz> <BANLkTikaymG-5-YoTnG2SPJCnBtXPpfHBQ@mail.gmail.com>
 <201104160111.49409.rjw@sisk.pl>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 15 Apr 2011 19:24:47 -0400
X-Google-Sender-Auth: HB7kUYyx_Ri6BmZ1t83aVodcrhs
Message-ID: <BANLkTik9aGTqb0JNr3RsnDjPiSpbSdEUpA@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [linux-pm] freezer: should barriers be smp ?
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 19:11, Rafael J. Wysocki wrote:
> On Friday, April 15, 2011, Mike Frysinger wrote:
>> On Fri, Apr 15, 2011 at 12:29, Pavel Machek wrote:
>> >> > > I believe the code is correct as is.
>> >> >
>> >> > that isnt what the code / documentation says.  unless i'm reading them
>> >> > wrong, both seem to indicate that the proposed patch is what we
>> >> > actually want.
>> >>
>> >> The existing code is correct but it isn't optimal.
>> >>
>> >> wmb() and rmb() are heavy-duty operations, and you don't want to call
>> >> them when they aren't needed.  That's exactly what smp_wmb() and
>> >> smp_rmb() are for -- they call wmb() and rmb(), but only in SMP
>> >> kernels.
>> >>
>> >> Unless you need to synchronize with another processor (not necessarily
>> >> a CPU, it could be something embedded within a device), you should
>> >> always use smp_wmb() and smp_rmb() rather than wmb() and rmb().
>> >
>> > Maybe; but this code is not performance critical and I believe being
>> > obvious here is better...
>>
>> isnt it though ?  especially when we talk about suspending/resuming on
>> embedded systems to get more savings over just cpu idle ?  we want
>> that latency to be as low as possible.
>
> I agree, we can switch the freezer to smp_ barriers, but not for the reason
> you gave before. :-)
>
> Care to repost the patch with a suitable changelog?

np

to be clear, what you said wrt the Blackfin smp barriers still holds
true right ?  so this changset i merged doesnt need any tweaking ...
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=943aee0c685d0563228d5a2ad9c8394ad0300fb5
-mike
