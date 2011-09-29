Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1I2Mi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:38:29 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:51683 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1I2Mi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:subject:from:to:mime-version:content-type:
	content-transfer-encoding; q=dns; s=shealevy.com; b=duaLD8QeohlD
	CDD6FuDA4yHq2tYGpaU+h5wNLUKDd776P/sv5DPKBHsXKG0L6+worSxoRvOGlCdc
	ZAGhsO24PGKfgeH3cQ5PMeEoTRFm3z7G9DA00l7ezi+Rf2qLQW1ERUEKsM90tNu8
	OJGqeF4eJobnvcB0QxV4uKFb4+Vvx6I=
Message-ID: <7ca3debde28dcc206c1f6f787df5c619.squirrel@webmail.shealevy.com>
Date: Thu, 29 Sep 2011 05:38:27 -0700
Subject: Hang with "runaway loop modprobe net-pf-1" on Linux 3.0.4
From: shea@shealevy.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My initrd mounts /proc and /sys, puts a tmpfs at /dev, then loads ext4. On
2.6.39 (and earlier), this works fine and the initrd init continues
happily. On 3.0.4, however, the kernel spits out

> request_module: runaway loop modprobe net-pf-1

a few times then hangs. If I drop into a shell before loading ext4 and run
modprobe unix, the same problem occurs. The modprobe used is dynamically
linked with glibc (which is included in the initrd), and it is the same
modprobe on the working and non-working systems. From my searches, it
appears that CONFIG_UNIX=y instead of =m would probably solve this
problem, but I'd rather keep it as a module if it's possible to get it
working. What's going wrong here? Why does it work on 2.6.39 but not
3.0.4?

Regards,
Shea Levy

