Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2EKJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab2EKJQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:16:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Fri, 11 May 2012 09:16:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@redhat.com, remi@remlab.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
References: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1336629727-11111-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205110916.11308.arnd@arndb.de>
X-Provags-ID: V02:K0:QC1G47hN7p3VEMZcEKVZ+rYFFJ8r7cJq7Dx/v718T0I
 zlm4u6LG/3P4aGEhywLNBxlaRx4CgGhUgO3HD8CKW/2rwsdO4r
 f942/otDzexgK8+mxOCetfu/xeDAqZ0yCv5hqmj8MD9DDsJrTG
 PAFmVRvqrt//MaoucdSHDwwU+h8dc+uZS+kKG+lcn/Nt/6iIdK
 LtSq6Ra6EH8U+FvjdjbSZ4p5j9HhqiTZMm7AIDKtXtkFbQSS1U
 6NTkhy+OluN3LMmGKfZOe1ozLt2KsKKrMBs6bthPi7Qhb49NMI
 GrTkUmezkbC//P0TQSqFQ4L8fkxyOJIuU38Ur89Jwx68kPjm+R
 zGqB6Rfy77dr5muuejUo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Sakari Ailus wrote:
> The issue boils down to whether enums are fundamentally different from __u32
> or not, and can the former be substituted by the latter. During the
> discussion it was concluded that the __u32 has the same size as enums on all
> archs Linux is supported: it has not been shown that replacing those enums
> in IOCTL arguments would break neither source or binary compatibility. If no
> such reason is found, just replacing the enums with __u32s is the way to go.

Well, ARM Android was building stuff with short enums for a while, but it
seems that was corrected now, and using __u32 would in this case only
help maintain compatibility when mixing android kernels with regular
user space or vice versa.

	Arnd
