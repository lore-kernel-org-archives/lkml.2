Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967955Ab2ERKGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:06:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967889Ab2ERKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:06:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Bcache v13 00/16]
Date: Fri, 18 May 2012 10:06:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
References: <cover.1336619038.git.koverstreet@google.com>
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205181006.04575.arnd@arndb.de>
X-Provags-ID: V02:K0:J16oyAfcliy0mfWXWY3HoRKWZxzxOVsGRtjQKPvuVEz
 9KmgCtLE5aVtkaf9HZCSWSat6xhBH2Pfg5pyd3JfdT1YOHN3yG
 vc1dYEoHDxHuZJrITz+/ZGsF41bNmZnnSE6IqEKzLx+twM+AKl
 4iESc9gyJ2UgUU6O8I641DDqyLpLwIUFfCuCugQdsDXGgYq9DO
 stz14P4ux0dT3WbrAA35fzUN4xiJb0jjFyt1wyF2lQXGDOjv2Y
 oSSm3B5bF4sPv3YIy8enxT4KJaH1EBeXfD6j5R1GLaNlNFFxjU
 MuhPEJI7ofLMP2aMY6NTAIix9w/IA/DYhGWiAuunxda6MaLoKB
 tUUlFBSIUuJzRe+DvtYE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Kent Overstreet wrote:
> TODO/known issues:
> 
> __up_write() needs to be exported for bcache to compile as a module - it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me know.
> 
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.
> 
> Documentation needs to be updated. That's being actively worked on, though.

Hi Kent,

Sorry for jumping in late in the discussion. I believe we discussed the
requirements for the low-end media when you posted v12 and it seemed that
there are issues with a lot of the low-end media you were planning to
support. I have seen devices with 12MB or 16MB erase block size, which you 
didn't handle well, and many devices are severely limited on the number of
buckets (erase blocks that a device can write to concurrently), typically
3 to 8 for an SD card and slightly more for a USB drive.

Are you still planning to support those devices or are you focusing now
on other hardware? If you plan to support them, what are you current
limits on the bucket size and the number of buckets?

FWIW, Tixy has written a tool named flashsim[1] to simulate the behavior
of all kinds of flash drives, so you can use a blocktrace file as
input and it will tell you the write amplification factor that a given
drive would suffer given that workload. You can use it to find out how
your algorithms would interact with devices that can only support a
smaller number of buckets that you would actually want.

	Arnd

[1] http://yxit.co.uk/public/flash-performance/
