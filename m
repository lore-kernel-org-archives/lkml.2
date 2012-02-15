Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2BOWl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:41:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2BOWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:41:27 -0500
Message-ID: <4F3C3492.9080207@opersys.com>
Date: Wed, 15 Feb 2012 14:41:22 -0800
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Headless Android (no FB required)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As an FYI, I thought some of you might be interested in knowing that 
Android's user-space can be modified to run on headless systems (i.e. 
without a framebuffer.) IOW, you can configure the FB stuff completely 
out or have a kernel port that doesn't have an FB (yet?) and still run 
the Android use-space.

I've put this up as part of the Cyborgstack project:
$ repo init -u git://github.com/cyborgstack/android.git -b headless
$ repo sync
$ ...

The relevant presentation from the Android Builders Summit is here:
http://www.cyborgstack.org/www.cyborgstack.org/sites/default/files/headless-android-120214.pdf

Essentially, Headless Android is the AOSP but WITHOUT:
- SurfaceFlinger
- WindowManager
- WallpaperService
- InputMethodManager

It gives you is all the Android framework but for ui-less systems (no 
FB.) What it means, is that, save for Activities, you can use the 
standard Android development tools (Eclipse, SDK/NDK, etc.) to create 
apps that use:
- ContentProviders
- Services
- BroadcastReceivers

Why would you want this instead of using "Embedded Linux"? Honestly I 
was very skeptical when some developers first mentioned to me that they 
were interested in doing this. I was in fact very dismissive of it. But 
I kept getting more and more inquiries about this. So I decided to bite 
the bullet and give it a try.

Now that I have, I think there are 2 clear benefits to using this 
instead of "embedded Linux":
1) you get one platform for all your device development, whether it has 
a UI or not
2) your devices become programmable by any developer that knows the 
Android API (and, as you may know, there's growing number of those.)

That said, what I've done is very much a proof of concept. It's in fact 
a dirty hack at this point. Please don't ship this just yet. It needs a 
lot more eyeballs and certainly a lot more work. But, it's good enough 
to give you a taste of what's possible and allow you play with it.

Cheers,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
