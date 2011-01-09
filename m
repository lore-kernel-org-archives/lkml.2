Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1AIMpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 07:45:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40731 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1AIMpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 07:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Qka6Yzyuld6asqkq7q4gna9mmQYnjwhSiiY3iAgH2Yzf/Xj7nsgdi3ULvD+xYhetZw
         9VP72uWplk4JwZiaNs58dxccmfhaIdXsEiPTiFyESaVQBWgftqUEGnD5oiJBw6UNAGl1
         uXlZyCAv9R1KoTZ0QtAXQcABpd4CsArZKxvRQ=
Date: Sun, 9 Jan 2011 13:44:23 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: chris@chris-wilson.co.uk
Subject: 2.6.37: *ERROR* Attempting to mmap a purgeable buffer
Message-ID: <20110109124423.GA9131@Pilar.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to report an issue which just happened while using 2.6.37.

I was transfering some large files between two external harddisks
using btrfs and suddenly my window manager exited and I was left
in the login screen of kdm.

The end of dmesg looks like:

[42460.335771]  sdd: sdd1 sdd2 sdd3 sdd4
[42460.337496] sd 34:0:0:0: [sdd] Assuming drive cache: write through
[42460.337500] sd 34:0:0:0: [sdd] Attached SCSI disk
[42468.912626] device fsid 4b41009f616ab3b8-a8cf4357d5b54bb4 devid 1 transid 950 /dev/sdd2
[42468.913839] btrfs: use compression
[42893.878855] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer

and before that there is nothing out of the usual. After starting the
window manager again all things look ok. I am reporting this anyway, in case
it might help improving the kernel and making it stabler.

The error string is from ab18282d58c ("drm/i915: Warn before mmaping a purgeable 
buffer.") from 2009, so I'm cc:ing the author.

My laptop is a 64-bit Vaio with

Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)

and today was the first time this error happened, afaict.

Is there something else I can do to help? Is this something fixable in the
kernel or was it an error with my hardware? Suddenly being kicked out of X is 
quite bad, so I hope this can be fixed :-)


