Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3AJSBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:01:17 -0500
Received: from sealard.tedial.com ([62.15.229.231]:41134 "EHLO
	sealard.tedial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3AJSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:01:14 -0500
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 13:01:14 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2013 18:32:33 +0100
From: "Larrosa, Antonio" <antlarr@tedial.com>
To: <linux-kernel@vger.kernel.org>
Subject: seteuid and /proc/<pid>/exe
Message-ID: <7ce5db09b3a7556682a61a4fad23b2c8@tedial.com>
User-Agent: Roundcube Webmail/0.7.2-2.el6.kolab_2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a user with uid=1000 that runs a process, let's say with pid 42.

If I do a readlink on /proc/42/exe from another process run by that 
same user,
it reads the link correctly.
If root calls readlink on that same link, it works correctly.

The problem is that I have another process that is run by root, and 
then calls
seteuid(1000). When it tries to read that link, it fails with 
"permission denied".
I could just seteuid(0), read the link and seteuid(1000) again
(I checked it and it works) but I wonder if that's really the expected 
behaviour.

If any of the effective, real and saved uid of the process have 
permissions to read the link,
is it expected that only because they're different, then the permission 
is denied?

Thanks,

-- 
Antonio Larrosa
