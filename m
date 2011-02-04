Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1BDELR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:11:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43613 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1BDELQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:face:mime-version
         :content-type:content-transfer-encoding;
        b=MiENIvmyQ5tcZVHeA5jbsYX/hArJMAuJNmrTmTNu5T25z2frN1Ionyp8suk/iCHXBL
         gcXjEVlHbgGhpsDC/0INNCaaoT3E6w3wcUn6MHFL1zmd6JW9La5+XKOgg9WxrqPsbIUZ
         RL4wE5f76F1Yen6JRsCvKtOQdGOQtI/hPGPiM=
Date: Thu, 3 Feb 2011 22:11:08 -0600
From: Bobby Bingham <uhmmmm@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: drm:i915_hangcheck_elapsed
Message-ID: <20110203221108.281c8512@duality>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAABhQTFRFCgYMLBEpThdDgTVgc1Jl3XeZ36FM2bm4ve5MKQAAAmtJREFUOMtVk01z2yAQhsFVJldA6uQagXOPhXU3zto6pzLtD6hHuSYzcvj7fRcUu9mxvvbZdz8ACyWEjLixyTbf7SM/Aq74XICwHLHqMhjVf8Cwy7oM4qZc2VYWt87m9zjuRAwLEAheuQIOsb4pBOrWpQQkv1R8FbdcNncghbgbHw9FIRlILqHbIJ6RqC9AtxrxEBi7ViK+3vkFCGdbAIaYNMbNWG/K6NJaY1tjuw4ffYy9M7me0RrBuDr+rGto+O0ljn4PYJ1dlqzuO6fET/i9X1tb2sVIXYuK6keMY++d7wDKOjgHrdWHnkEfPQLtooC/NeyL3o3d2nZFUnvuBGDsUCWiPrIxYH+rLYCPmxC3ZPdd2RYGxvb96KKnHsCtDfeLOa1uvesjg6ct7bGDnMv4diPbJxQ3cX06bImc2/FK+I1X0jrPippe/AG5gkSRsd/h2GDoWKMyK/ZoF4D3W5rOb+L2UBObafdCl3MldKe3AAjHT5vrERC6duj075YFRymfryDBLn46nonmo17tvvxVGmi+jNM0nYgmIdVVUQ0pDXuAt8vnJCpxsyp9pvk4TZ8pncU3u0cV+n0+zUTv38DQINv5DxRp9w2k8JAW+xqhtKBQBnaa0/vi0wsRBP/cBK7Q8HJIrXUGYUjD8YVbbZRQ5fy1LAqBPoa3HKIrBjjjLKmQUw0fnEMpaIQ2ps0gBB0oD6sUoWWNMwJeEcl7RUyU1PxoS/EhET1QBkE2TW6XAQ9BA9aDx9b5LjLgpUoEVRBSSiqj8YgZzMNlJsSH62pJlMgSmK4kXf1fABuJ4fRtA6VaQKJGqxD4H/8PjSueXT5olWEAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On my Sandybridge desktop, I occasionally had an issue under 2.6.37
where I would get something like this in my dmesg output and the X
display would stop updating, except that the mouse cursor could still
move:

[   67.742300] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[   67.743736] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 1669 at 1372, next 1673)

This only happened occasionally, usually when a new window appeared on
the screen or when I switched virtual desktops, but most of the time it
was fine.

I upgraded to 2.6.38-rc3, and it now happens consistently just in the
process of logging in.  gdm feels laggy, and X locks before xfce
finishes loading.

It's my first time working with git bisect, but the culprit seems to be
this commit:

8fd2685911cb6c140e6d0588ac04990ce65d4537 (drm/i915: Enable RC6 autodownclocking on Sandybridge)

If you need me to run with some sort of debugging output to help fix
this, just let me know.  Please CC me as I'm not subscribed.

-- 
Bobby Bingham
このメールは再利用されたバイトでできている。
