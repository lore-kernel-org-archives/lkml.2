Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1DFGEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:04:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45255 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1DFGD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ginkel.com; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=V/+kWnUDnlPMfL8YAPc45NQqtUGkfBKZpA3dpbDOMrrqYP060gRXC8yTF3h1iwTVTz
         3YPKcl4/bB5pVFf/8Q0BrIP544PVpP3p5abqZ/gGrHc45D3+lqHgnTXUvRZX7P6c7I9L
         xNYEZSYdkWA1zKpqNErAfSz3yWLr0eRMFkBTI=
MIME-Version: 1.0
X-Originating-IP: [91.17.164.56]
In-Reply-To: <201104060128.33887.arnd@arndb.de>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com> <201104060128.33887.arnd@arndb.de>
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
Date: Wed, 6 Apr 2011 08:03:26 +0200
Message-ID: <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 01:28, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 05 April 2011, Thilo-Alexander Ginkel wrote:
>> Thanks, that worked pretty well. A bisect with eleven builds later I
>> have now identified the following candidate commit, which may have
>> introduced the bug:
>>
>> dcd989cb73ab0f7b722d64ab6516f101d9f43f88 is the first bad commit
>> commit dcd989cb73ab0f7b722d64ab6516f101d9f43f88
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Tue Jun 29 10:07:14 2010 +0200
>
> Sorry, but looking at the patch shows that it can't possibly have introduced
> the problem, since all the code that is modified in it is new code that
> is not even used anywhere at that stage.
>
> As far as I can tell, you must have hit a false positive or a false negative
> somewhere in the bisect.

Well you're right. I hit "Reply" too early and should have paid closer
attention to what change the bisect actually brought up.

I already found a false negative (fortunately pretty close to the end
of the bisect sequence) and also verified the preceding good commits,
which gives me two new commits to test. I'll provide an update once
the builds and tests are through, which may however take until early
next week as I will be on vacation until then.

Regards,
Thilo
