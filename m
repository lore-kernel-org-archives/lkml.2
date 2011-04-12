Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1DLTVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab1DLTVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:21:39 -0400
Date: Tue, 12 Apr 2011 15:21:03 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110412192103.GA13278@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412190934.GA12082@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 03:09:34PM -0400, Dave Jones wrote:

 > however, the output of mount looks very confused..
 > 
 > .38:
 > /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
 > 
 > .39:
 > - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
 > 
 > It looks like /proc/self/mountinfo broke abi.
 > 
 > .38:
 > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
 > 
 > .39:
 > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered

looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f

perhaps adding that string to the end of the line would preserve what mount expects ?

	Dave
