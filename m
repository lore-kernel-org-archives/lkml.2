Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2AZV5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:57:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2AZV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:57:31 -0500
Message-ID: <4F21CC40.3030207@canonical.com>
Date: Thu, 26 Jan 2012 13:57:20 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: apparmor@lists.ubuntu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, draht@suse.com
Subject: Re: security_path hooks for xattr
References: <87fwf2y6mw.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87fwf2y6mw.fsf@tucsk.pomaz.szeredi.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:45 AM, Miklos Szeredi wrote:
> Forwarding from an internal bug report:
> 
>    "AppArmor does not mediate the xattr system calls for confined processes.
> 
>    As a consequence, a confined process can cross the confinement privilege
>    boundary by reading or writing to extended attributes that the confined
>    task should not have access to. The restrictions for security and user
>    attributes read and write still apply according to DAC; however, this
>    does not comply with the claim of AppArmor to mediate fipe
>    operations. The use of extended attributes is very flexible, so that the
>    effect of a missing mediation can lead to false assumptions in
>    subsequent policy decisions (eCryptfs)."
> 
> AFAIU this boils down to missing security hooks in *xattr().
> 
> Would it be possible to add these hooks?
> 
right, this is something we lost when we moved to the security_path hooks and
while we have spent some time looking at the problem, we haven't addressed it
yet.  

New hooks would certainly be the easiest solution. I looked at it back when
I initially did the port, and considered proposing new hooks at the time, but
for various reasons it was decided to separate that from the main apparmor
submission, and I haven't had a chance to revisit this since.

