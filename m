Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1DNIU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:20:26 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37268 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1DNIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:20:24 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Linux 2.6.39-rc3
In-Reply-To: <20110412192103.GA13278@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 14 Apr 2011 13:50:16 +0530
Message-ID: <87tye1ckhr.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 15:21:03 -0400, Dave Jones <davej@redhat.com> wrote:
> On Tue, Apr 12, 2011 at 03:09:34PM -0400, Dave Jones wrote:
> 
>  > however, the output of mount looks very confused..
>  > 
>  > .38:
>  > /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
>  > 
>  > .39:
>  > - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
>  > 
>  > It looks like /proc/self/mountinfo broke abi.
>  > 
>  > .38:
>  > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
>  > 
>  > .39:
>  > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
> 
> looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
> 
> perhaps adding that string to the end of the line would preserve what mount expects ?

uuid:<value> is the option field  as per
Documentation/filesystem/proc.txt. There was an error in libmount
parsing which got fixed upstream recently 

you can find the details here 

http://thread.gmane.org/gmane.linux.kernel/1121533/focus=52474

-aneesh
