Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1HXPcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:32:10 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:33171
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1HXPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:32:08 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 11:32:08 EDT
Message-ID: <4E551331.1010709@acm.org>
Date: Wed, 24 Aug 2011 09:05:21 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v2
References: <20110824085329.GL29452@sun>
In-Reply-To: <20110824085329.GL29452@sun>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20110824/1QwF1R-000763-5Q-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/2011 2:53 AM, Cyrill Gorcunov wrote:
> From: Pavel Emelyanov <xemul@parallels.com>
> 
> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> one for each mapping with file, the name of a symlink is vma->vm_start, the
> target is the file. Opening a symlink results in a file that point exactly
> to the same inode as them vma's one.
> 
> This thing is aimed to help checkpointing processes.
> 
> For example the ls -l of some arbitrary /proc/<pid>/map_files/
> 
>  | lr-x------ 1 cyrill cyrill 64 Aug  9 15:25 0x3d73a00000 -> /lib64/ld-2.5.so
[snip]

Just curious: How do these symlinks work when the process reading a
/proc file is in a chroot or a different namespace?

For example, a chroot environment might have independent copies of
/lib64/ld-2.5.so and a bind mount of /proc. Does the symlink then point
to the wrong file?
