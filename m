Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0DNVFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:05:16 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:41812 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:05:14 -0400
Date: Wed, 14 Apr 2010 14:04:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Peter M. Petrakis" <peter.petrakis@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reset ps/2 port should psmouse_probe fail before
 retrying
Message-Id: <20100414140422.b6054dbc.randy.dunlap@oracle.com>
In-Reply-To: <4BC629A5.4040500@canonical.com>
References: <4BC629A5.4040500@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BC62E05.0149:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 16:46:29 -0400 Peter M. Petrakis wrote:

> Filed a bug on this too:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15780
> 
> This particular laptop will lose it's synaptics touch
> pad on return from suspend state. Reloading the psmouse
> module makes no difference. I came up with the attached
> work around which simply calls psmouse_reset on the
> port should the initial probe fail. This solves the problem
> for me and I've tested this on several laptops.
> 
> Initially discovered on Ubuntu 2.6.31 (karmic) and the problem
> continues to exist in lucid 2.6.32. I've filed a bug against
> ubuntu kernel here:
> 
> https://bugs.launchpad.net/oem-priority/+bug/551234
> 
> though the Ubuntu kernel team would really like to get upstream's
> input on the matter before accepting the patch. Please
> let me know what you think. Thanks.

Hi,

Please send patches inline, not as attachments.
Use the full source file path in the patch.
Send the patch to linux-input@vger.kernel.org and cc: the Input
subsystem maintainer.

typo:  s/reseting/resetting/


Other than those 4 things, the patch looks OK to me.
Well, we would prefer not to have the
	((ret = __psmouse_probe(psmouse)) != 0)
inside the for expression if possible.  I.e., make the for(...) simpler.


Please read/review Documentation/SubmittingPatches.  Thanks.

---
~Randy
