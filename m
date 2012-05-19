Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968276Ab2ESAyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:54:37 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:55222 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966670Ab2ESAyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:54:35 -0400
Message-ID: <4FB6EF47.2040107@molgaard.org>
Date: Sat, 19 May 2012 02:54:31 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/15.0 Firefox/15.0a1 SeaMonkey/2.12a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Boot failure since 3.3-rc?
References: <4F931C6D.8040407@molgaard.org>
In-Reply-To: <4F931C6D.8040407@molgaard.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem solved.

At some point between 3.3-rc3 and 3.3-rc4, something has made the uuids 
in /dev/disk/by-uuid/ different from the uuids that are embedded in md 
raid member v 0.90 metadata.

Failure at my end was caused by my adding (mdN) entries to 
/bot/grub/device.map at some time in the past, mapping them to the 
entries there.

Changing said entries to point to symlinks in /dev/disk/by-id solved 
this for me.

Problem was compunded by the use of initrd since, as one will readily 
surmise post-hoc, a kernel with no other problems will boot if the 
corresponding initrd image was built under a kernel with the old 
behaviour wrt. to /dev/disk/by-uuid mappings, thus prompting one to "git 
bisect good", whereas the kernel built while being booted in that 
kernel, with the initrd image being built under it will fail if it 
exhibits the new behaviour, leading to an off-by-one in the binary 
search of git bisect.

This mail is meant jointly as a "problem solved" message to this list, 
and as explanation for posterity if someone else happens to run into 
similar problems.

Initial confusion was mainly due to the lack of an attached monitor, the 
acquirement of which showed the eroor to be one of failure to mount the 
root fs, and even if that might have been seen via netconsole, I decided 
to order one before realising that some of the kernels would label my 
two ethernet cards differently than what udev picked up at one time and 
made permanent...

In closing: Thank you all for your input and sorry for the noise.

Best regards,

Sune Mølgaard

-- 
Nothing exists except atoms and empty space; everything else is
opinion.
- Democritus


