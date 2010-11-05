Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0KEHOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:14:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48810 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab0KEHOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lP6jXVshzD/hB1EbUmVnAlVFnULOKCz+TW5q7zm+HHfb+nSrhbCmRTN61f4k8ndWoR
         mesJzSBQv3v1D/R3NSYntZzqap81UqOPmt+1V8IN2E7N1ogJwXymMfR//n5Qtbqalcve
         0NaCsq82vo6NAaQ0TmWR2xtDRGVOZPXDFimVE=
MIME-Version: 1.0
In-Reply-To: <201011050327.06607.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
	<20101102012135.GB2648@ucw.cz>
	<AANLkTim=suDPVCW+dPCxtasbUj=X8EMgGRHAiGO37cGo@mail.gmail.com>
	<201011050327.06607.arnd@arndb.de>
Date: Fri, 5 Nov 2010 09:14:02 +0200
X-Google-Sender-Auth: ntxtr9G9wQHHmcuuekcwejLaD1Y
Message-ID: <AANLkTimm79DJaLcr2rxz1UWd1SNdf+=s7y_YO_+N5g0d@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Pekka Enberg <penberg@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
        Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
        Valdis.Kletnieks@vt.edu, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 4:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 03 November 2010, Pekka Enberg wrote:
>> On Tue, Nov 2, 2010 at 3:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >> @@ -79,6 +79,10 @@ static struct drm_driver driver = {
>> >>
>> >>  static int __init i810_init(void)
>> >>  {
>> >> +     if (num_present_cpus() > 1) {
>> >> +             pr_err("drm/i810 does not support SMP\n");
>> >> +             return -EINVAL;
>> >> +     }
>> >>       driver.num_ioctls = i810_max_ioctl;
>> >>       return drm_init(&driver);
>> >
>> > Umm, and now someone onlines second cpu?
>>
>> Well, I see it's being fixed in a different way but yeah,
>> num_possible_cpus() would be more appropriate here.
>
> (trimming Cc list again)
>
> I thought that patch was still current, what other way are we fixing it now?

Oh, I just read the thread wrong. If you repost with
num_possible_cpus, feel free to add my ACK.
