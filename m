Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1K2KZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:25:10 -0500
Received: from volnay.nexen.net ([89.31.144.90]:52371 "EHLO volnay.nexen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab1K2KZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:25:09 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 05:25:09 EST
Message-ID: <4ED4B174.80300@nexen.alterway.fr>
Date: Tue, 29 Nov 2011 11:18:28 +0100
From: Vivien Bernet-Rollande <vivien.bernet-rollande@nexen.alterway.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Flushing block-level read cache for a single (shared) device.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list.

I have two Xen hypervisors. Virtual machines use raw ISCSI devices for 
storage.

I ran into a cache coherency issue with live migration.

Let's say VM "a" runs on hypervisor "x1", and I want to move it to "x2". 
This works fine.
Now, I let "a" do some file system operations on "x2".

The problem arises when I move "a" back to "x1". What happens is x1 
still has it's old caches for the iscsi LUN. After a few minutes, the 
filesystem of the VM gets heavily corrupted, and is basically unrecoverable.

I'm currently working around this issue by running something like "sync; 
echo 3 > /proc/sys/vm/drop_caches" on the destination before any 
migration. This works, and I no longer have any data corruption. However 
I feel dropping all caches is not a satisfying solution.

I'm looking for a way to invalidate the cache for a single block device. 
I know of BLKFLSBUF to flush write buffers, but I couldn't find anything 
related to read caches.

-- 
Vivien Bernet-Rollande
Systems&  Networking Engineer
Alter Way Hosting

