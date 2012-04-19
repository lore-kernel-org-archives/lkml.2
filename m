Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2DSVAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:00:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59657 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab2DSVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:00:38 -0400
Date: Fri, 20 Apr 2012 01:00:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, khlebnikov@openvz.org, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: +
 c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-
 num_exe_file_vmas-removal.patch added to -mm tree
Message-ID: <20120419210033.GO1893@moon>
References: <20120419185221.E8ED6A055E@akpm.mtv.corp.google.com>
 <20120419192005.GA13558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419192005.GA13558@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 09:20:05PM +0200, Oleg Nesterov wrote:
> On 04/19, Andrew Morton wrote:
> >
> > From: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal
> >
> > [ fix for "c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2" from mm tree ]
> >
> > After removing mm->num_exe_file_vmas kernel keeps mm->exe_file until final
> > mmput(), it never becomes NULL while task is alive.
> >
> > We can check for other mapped files in mm instead of checking
> > mm->num_exe_file_vmas, and mark mm with flag MMF_EXE_FILE_CHANGED in order
> > to forbid second changing of mm->exe_file.
> 
> I lost the track a long ago.
> 
> Just one question, what does this "forbid second changing" actually mean?

Heh :) Oleg, it was actually your idea to make this feature "one-shot".
Once exe-file changed to a new value, it can't be changed again. The
reason was to bring at least minimum disturbance in sysadmins life.

	Cyrill
