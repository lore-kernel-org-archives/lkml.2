Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0GZJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:13:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43506 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab0GZJNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VaYFad7iPvX6dSKi6H7xrwUt0X1641wFVHjCV/0+zk8cq36PNpVztx4LgSNDsy0Ae7
         WqGFPuzI5nF8MOqTquxiOeioluffW0spp1kofweoLcO/YRIVJ5TvS1heauj9twotpXKC
         4ygPMxidXTyUdV9dPC/Y0MNGH8bwALt9zmVpM=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AbrDaOzvdmb72F+Kye0Znyk3OW2liDRdnO4vBvurlOq+m3KAmjJac+TnjXQ5CbUHsy
         XummhGaTKESDJ4XSwesixggXf4zEB1ljtW23KShf3wMxQcMrNf5JFW88SkFcfn6OwE7T
         RwHM34L8LDK9CcuWFBSytnTrkL/AUNh3BpJ6s=
MIME-Version: 1.0
In-Reply-To: <AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
	<AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
Date: Mon, 26 Jul 2010 11:13:14 +0200
Message-ID: <AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:12 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, Jul 26, 2010 at 11:08, Dhaval Giani <dhaval.lists@thegianis.in> wrote:
>> On Thu, Jul 22, 2010 at 8:36 PM, Greg KH <gregkh@suse.de> wrote:
>>> On Thu, Jul 22, 2010 at 11:31:07AM -0700, Paul Menage wrote:
>>>> On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
>>>> > We really shouldn't be asking userspace to create new root filesystems.
>>>> > So follow along with all of the other in-kernel filesystems, and provide
>>>> > a mount point in sysfs.
>>>> >
>>>> > For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
>>>> > that mount point when the cgroup filesystem is registered in the kernel.
>>>>
>>>> But cgroups will typically have multiple mounts, with different
>>>> resource controllers/options on each mount. That doesn't really fit in
>>>> with this scheme.
>>>
>>> Really?  I see systems mounting it at /cgroups/ in the filesystem today.
>>> Where are you expecting it to be mounted at?
>>>
>>
>> Not really. It is getting mounted at /cgroups/<name of resource
>> controller>/ at a number of places. Keeping it in sysfs loses us a lot
>> of this flexibility. Unless you are ready to keep adding a new
>> mountpoint for each subsystem, it will not really work out in the long
>> term.
>
> As mentioned earlier in this thread, systemd already mounts a tmpfs at
> the cgroup mountpoint. We need only a single directory. This should
> not be an issue.
>

Ah ok. I am catching up with email after over 3 weeks :-). Missed all
this discussion. My apologies!

Dhaval
