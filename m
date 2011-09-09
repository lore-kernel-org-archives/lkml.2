Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab1IIO35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:29:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1IIO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:29:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Cloos <cloos@jhcloos.com>
Subject: Re: found __[us]{8,16,32,64} type without #include <linux/types.h>
Date: Fri, 9 Sep 2011 16:29:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mm@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <m3vct1u75k.fsf@jhcloos.com>
In-Reply-To: <m3vct1u75k.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091629.52879.arnd@arndb.de>
X-Provags-ID: V02:K0:BlX2dsLaOJ8IkxbuNmNVADOoPA4cHmGSAr4LXJK02IU
 8S+MScP4aLU995iOXXYR7jc3mvRLSxLNLCYETtERbW6zmiCUWr
 m7mfQtYY8pyHojZmXnM7r1uolNSetMOlaGuhOJVWGW2wso/xcc
 f+/cWTzt6elj/D3Rsi3eoKG4KTvRr2bPWNP4GU+klJgKeb/yQy
 KTklj3IfT72JrkYqRh/fxxO5o3BmNZ2H7oEIxRbJb5J4/wfuFn
 /9yW9v0rSfytC8x1BaOkjXXd3BnrryMq240et4kncGH0KPJwVM
 5+CY6XugBVb1BlzSRJIehCxGgyb4omS4QB1zN+lHIcd+spkEZz
 XHAGV7gWjEYXFbEhB/7A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011, James Cloos wrote:
> All noticed while compiling 3.1-r5:
> 
> linux/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

This has been around for a long time, I think. I agree that we should do
something about it, but I think we're still looking for a solution that
makes everyone happy.

The script only checks for direct inclusions of types.h, while the drm headers
get it from drm.h. One solution would be to make the script smart enough
to evaluate all indirect header inclusions as well. A more hacky workaround
would be to just treat "drm.h" the same as <linux/types.h>.

	Arnd
