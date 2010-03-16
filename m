Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937299Ab0CPBFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:05:24 -0400
Received: from crca.org.au ([74.207.252.120]:34881 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937264Ab0CPBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:05:22 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 21:05:22 EDT
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B9ED75F.1050600@crca.org.au>
Date: Tue, 16 Mar 2010 11:57:03 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: tuxonice-announce@tuxonice.net,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, lwn@lwn.net
Subject: TuxOnIce 3.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Almost a year since TuxOnIce 3.0 was announced, I'm pleased to announce 
a 3.1 release.

In the intervening period, lots of work has been done on the code. The 
major new features are:

- Support for LZO compression (deflate will also work, but it's slooow!)
- New sysfs entry making the sys_sync call in the freezer optional.
- Support for using swap AND file storage in the same image.
- Support for striped storage (swap priorities are now honoured and
   there's a new sysfs entry to set the priority of file storage).
- Binary signature now available through a sysfs entry (requires updated
   hibernate script).
- UUID support. This uses a simple table of UUID and filesystem
   signature offsets as the basis for scanning partitions for a TuxOnIce
   signature at resume time without the need for the resume= parameter.
   If more than one partition is used for storing the image, UUIDs will
   also be used for finding those partitions. This lets one user who had
   flakey device detection resume first time, every time, instead of
   having to reboot until the order is the same as that seen when
   hibernating. (New kernel commandline param: uuid_debug=1).
- (Extending the UUID support) Add support for checking last mount times
   of filesystems, and refusing to resume if a filesystem has been
   mounted since we hibernated. At the time of writing, we only know how
   to find these times for ext filesystems. (Note that the bytes don't
   need to be a mount time; they just need to be guaranteed to change
   if the filesystem is mounted in the meantime).
- We now display what storage from which devices was used in the image.
- Give an estimate of time remaining (text userui only at the moment).
- Reworked code which decides where the data will be loaded at resume
   time. Especially on machines with large amounts of memory, this will
   result in a signficant speed improvement in this phase of a cycle.

This release will be followed by updates to the hibernate script and 
userui so that they work without issue with 3.1 Once that's done, I 
intend to start focusing on seeking to improve the existing in-kernel 
implementation.

Regards,

Nigel
